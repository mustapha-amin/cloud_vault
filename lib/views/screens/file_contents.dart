// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/providers/files_selection_provider.dart';
import 'package:cloud_vault/services/files_display_prefs.dart';
import 'package:cloud_vault/services/pdf_service.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/screens/full_screen_image.dart';
import 'package:cloud_vault/views/screens/video_view.dart';
import 'package:cloud_vault/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import '../widgets/file_info_modal_sheet.dart';
import '../widgets/grid_file.dart';
import '../widgets/list_file.dart';

class FileContents extends StatefulWidget {
  final String title;
  final IconData iconData;
  List<CLoudVaultFile>? cloudVaultFiles;

  FileContents({
    required this.title,
    required this.iconData,
    this.cloudVaultFiles,
    super.key,
  });

  @override
  State<FileContents> createState() => _FileContentsState();
}

class _FileContentsState extends State<FileContents> {
  bool? isGrid;

  @override
  void initState() {
    isGrid = FileDisplayPreference.isGrid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filesProvider = Provider.of<FileProvider>(context);
    var fileSelectionProvider = Provider.of<FileSelectionProvider>(context);

    void deleteFiles(List<CLoudVaultFile> selectedfiles) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete"),
            content: Text(
                "Do you want to delete the selected ${fileSelectionProvider.selectedFiles.length == 1 ? widget.title.substring(0, widget.title.length - 1) : widget.title}?"),
            actions: [
              TextButton(
                onPressed: () {
                  for (final file in selectedfiles) {
                    filesProvider.deleteFile(
                        widget.title,
                        file.file!.name,
                        switch (widget.title) {
                          'images' => filesProvider.images,
                          'videos' => filesProvider.videos,
                          'audios' => filesProvider.audios,
                          _ => filesProvider.documents,
                        });
                  }
                  fileSelectionProvider.toggleIsLongedPressed();
                  fileSelectionProvider.clearSelected();
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("No"),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.capitalizeFirst),
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                fileSelectionProvider.clearSelected();
                fileSelectionProvider.isLongPressed
                    ? fileSelectionProvider.toggleIsLongedPressed()
                    : null;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back));
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isGrid = !isGrid!;
                });
                FileDisplayPreference.toggle(isGrid!);
              },
              child: Icon(
                isGrid! ? Icons.list : Icons.grid_view,
              ),
            ),
          ),
        ],
      ),
      body: filesProvider.isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: () async => {
                filesProvider.clearList(widget.cloudVaultFiles!),
                filesProvider.toggleNewFileUploaded(
                  switch (widget.title) {
                    'images' => filesProvider.newImageUploaded,
                    'videos' => filesProvider.newVideoUploaded,
                    'audio' => filesProvider.newaudioUploaded,
                    _ => filesProvider.newdocumentUploaded,
                  },
                  false,
                ),
                await filesProvider.loadFiles(
                  widget.cloudVaultFiles!,
                  widget.title,
                  newFileupladed: switch (widget.title) {
                    'images' => filesProvider.newImageUploaded,
                    'videos' => filesProvider.newVideoUploaded,
                    'audio' => filesProvider.newaudioUploaded,
                    _ => filesProvider.newdocumentUploaded,
                  },
                )
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: filesProvider.isLoading
                    ? const LoadingWidget()
                    : widget.cloudVaultFiles!.isEmpty
                        ? Center(
                            child: Text(
                              "You have'nt uploaded any files yet",
                              style: kTextStyle(context: context, size: 14),
                            ),
                          )
                        : isGrid!
                            ? GridView.builder(
                                itemCount: widget.cloudVaultFiles!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  final cloudVaultFile =
                                      widget.cloudVaultFiles![index];
                                  return GestureDetector(
                                    onLongPress: () {
                                      fileSelectionProvider.isLongPressed
                                          ? null
                                          : fileSelectionProvider
                                              .toggleIsLongedPressed();
                                      fileSelectionProvider
                                          .selectFile(cloudVaultFile);
                                    },
                                    onTap: () async {
                                      String? data;

                                      fileSelectionProvider.isLongPressed
                                          ? fileSelectionProvider
                                                  .containsFile(cloudVaultFile)
                                              ? fileSelectionProvider
                                                  .unselectFile(cloudVaultFile)
                                              : fileSelectionProvider
                                                  .selectFile(cloudVaultFile)
                                          : widget.title == 'documents'
                                              ? {
                                                  data = await PDFService
                                                      .loadDocument(context,
                                                          cloudVaultFile.url!),
                                                  PDFService.openLocalFile(
                                                      data!)
                                                }
                                              // ignore: use_build_context_synchronously
                                              : navigateTo(
                                                  context,
                                                  switch (widget.title) {
                                                    'images' => FullScreenImage(
                                                        file: widget
                                                            .cloudVaultFiles!,
                                                        index: index,
                                                      ),
                                                    'videos' => VideoView(
                                                        urls: widget
                                                            .cloudVaultFiles!
                                                            .map((e) => e.url!)
                                                            .toList(),
                                                        index: index,
                                                      ),
                                                    _ => Container(),
                                                  });
                                    },
                                    child: Stack(
                                      children: [
                                        GridFile(
                                          cloudVaultFile: cloudVaultFile,
                                          fileType: widget.title,
                                          extension: widget.title == 'documents'
                                              ? cloudVaultFile.file!.name
                                                  .split('.')
                                                  .last
                                              : null,
                                        ),
                                        fileSelectionProvider.isLongPressed
                                            ? Icon(
                                                fileSelectionProvider
                                                        .containsFile(
                                                            cloudVaultFile)
                                                    ? Icons.check_circle
                                                    : Icons.circle,
                                                color: fileSelectionProvider
                                                        .containsFile(
                                                            cloudVaultFile)
                                                    ? Colors.brown
                                                    : Colors.grey,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: widget.cloudVaultFiles!.length,
                                itemBuilder: (context, index) {
                                  final cloudVaultFile =
                                      widget.cloudVaultFiles![index];
                                  return GestureDetector(
                                    onLongPress: () {
                                      fileSelectionProvider.isLongPressed
                                          ? null
                                          : fileSelectionProvider
                                              .toggleIsLongedPressed();
                                      fileSelectionProvider
                                          .selectFile(cloudVaultFile);
                                    },
                                    onTap: () async {
                                      bool val = await PDFService.fileExists(
                                          cloudVaultFile.url!);
                                      log(val.toString());
                                      fileSelectionProvider.isLongPressed
                                          ? fileSelectionProvider
                                                  .containsFile(cloudVaultFile)
                                              ? fileSelectionProvider
                                                  .unselectFile(cloudVaultFile)
                                              : fileSelectionProvider
                                                  .selectFile(cloudVaultFile)
                                          : widget.title == 'documents'
                                              ? await PDFService.fileExists(
                                                      cloudVaultFile.url!)
                                                  ? PDFService.openLocalFile(
                                                      cloudVaultFile.url!)
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Download file"),
                                                          content: const Text(
                                                              "This document has to be downloaded before it can be viewed"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  PDFService.loadDocument(
                                                                      context,
                                                                      cloudVaultFile
                                                                          .url);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Proceed")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    "Cancel"))
                                                          ],
                                                        );
                                                      })
                                              : navigateTo(
                                                  context,
                                                  switch (widget.title) {
                                                    'images' => FullScreenImage(
                                                        file: widget
                                                            .cloudVaultFiles!,
                                                        index: index,
                                                      ),
                                                    'videos' => VideoView(
                                                        urls: widget
                                                            .cloudVaultFiles!
                                                            .map((e) => e.url!)
                                                            .toList(),
                                                        index: index,
                                                      ),
                                                    _ => Container(),
                                                  });
                                    },
                                    child: Row(
                                      children: [
                                        fileSelectionProvider.isLongPressed
                                            ? Icon(
                                                fileSelectionProvider
                                                        .containsFile(widget
                                                                .cloudVaultFiles![
                                                            index])
                                                    ? Icons.check_circle_sharp
                                                    : Icons.circle,
                                                color: fileSelectionProvider
                                                        .containsFile(widget
                                                                .cloudVaultFiles![
                                                            index])
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.grey,
                                              )
                                            : const SizedBox(),
                                        ListFile(
                                          cloudVaultFile: cloudVaultFile,
                                          fileType: widget.title,
                                          extension: widget.title == 'documents'
                                              ? cloudVaultFile.file!.name
                                                  .split('.')
                                                  .last
                                              : null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
              ),
            ),
      bottomNavigationBar: fileSelectionProvider.isLongPressed
          ? SizedBox(
              height: 8.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        fileSelectionProvider.toggleIsLongedPressed();
                        fileSelectionProvider.clearSelected();
                      },
                      icon: const Icon(Icons.cancel_outlined)),
                  if (fileSelectionProvider.selectedFiles.length == 1)
                    IconButton(
                        onPressed: () async {
                          final metaData = await fileSelectionProvider
                              .selectedFiles[0].file!
                              .getMetadata();
                          // ignore: use_build_context_synchronously
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return FileDetailSheet(metaData: metaData);
                            },
                          );
                        },
                        icon: const Icon(Icons.info_rounded)),
                  IconButton(
                      onPressed: () {
                        final selectedFiles = widget.cloudVaultFiles!
                            .where((file) => fileSelectionProvider.selectedFiles
                                .contains(file))
                            .toList();
                        deleteFiles(selectedFiles);
                      },
                      icon: const Icon(Icons.delete)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.cloud_download_sharp),
                  ),
                  if (fileSelectionProvider.selectedFiles.length == 1)
                    IconButton(
                        onPressed: () {
                          Share.share(
                            "Mustapha is inviting you to view his cloudvault file\n\n${fileSelectionProvider.selectedFiles[0].url!}",
                          );
                        },
                        icon: const Icon(Icons.share)),
                ],
              ),
            )
          : null,
    );
  }
}
