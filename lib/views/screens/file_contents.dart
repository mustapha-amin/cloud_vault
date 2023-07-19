import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/files_display_prefs.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/screens/full_screen_image.dart';
import 'package:cloud_vault/views/screens/video_view.dart';
import 'package:cloud_vault/views/widgets/future_network_image.dart';
import 'package:cloud_vault/views/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../widgets/grid_file.dart';

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

  void loadPdf(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    var filesProvider = Provider.of<FileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.capitalizeFirst),
        centerTitle: true,
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
                                    onTap: () {
                                      widget.title == 'documents'
                                          ? loadPdf(cloudVaultFile.url!)
                                          : navigateTo(
                                              context,
                                              switch (widget.title) {
                                                'images' => FullScreenImage(
                                                    file:
                                                        widget.cloudVaultFiles!,
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
                                    child: GridFile(
                                      cloudVaultFile: cloudVaultFile,
                                      fileType: widget.title,
                                      extension: widget.title == 'documents'
                                          ? cloudVaultFile.file!.name
                                              .split('.')
                                              .last
                                          : null,
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
                                    onTap: () {
                                      widget.title == 'documents'
                                          ? loadPdf(cloudVaultFile.url!)
                                          : navigateTo(
                                              context,
                                              switch (widget.title) {
                                                'images' => FullScreenImage(
                                                    file:
                                                        widget.cloudVaultFiles!,
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
                                    child: ListFile(
                                      cloudVaultFile: cloudVaultFile,
                                      fileType: widget.title,
                                      extension: widget.title == 'documents'
                                          ? cloudVaultFile.file!.name
                                              .split('.')
                                              .last
                                          : null,
                                    ),
                                  );
                                },
                              ),
              ),
            ),
    );
  }
}

class ListFile extends StatelessWidget {
  ListFile({
    super.key,
    this.extension,
    required this.fileType,
    required this.cloudVaultFile,
  });

  final CLoudVaultFile cloudVaultFile;
  final String fileType;
  String? extension;

  @override
  Widget build(BuildContext context) {
    var filesProvider = Provider.of<FileProvider>(context);
    void deleteFile() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text(
                "Do you want to delete this ${fileType.substring(0, fileType.length - 1)}?"),
            actions: [
              TextButton(
                onPressed: () {
                  filesProvider.deleteFile(
                      fileType,
                      cloudVaultFile.file!.name,
                      switch (fileType) {
                        'images' => filesProvider.images,
                        'videos' => filesProvider.videos,
                        'audios' => filesProvider.audios,
                        _ => filesProvider.documents,
                      });
                  Navigator.of(context).pop();
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              )
            ],
          );
        },
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 12.w,
                height: 12.w,
                child: switch (fileType) {
                  'images' => FutureNetWorkImage(
                      imgUrl: cloudVaultFile.url!, fit: BoxFit.fill),
                  'audios' => const Icon(Icons.audiotrack),
                  'videos' => const Icon(Icons.video_collection),
                  _ => Image.asset(
                      extension == 'pdf'
                          ? 'assets/images/pdf.png'
                          : extension == 'docx'
                              ? 'assets/images/word.png'
                              : 'assets/images/pptx-file.png',
                      fit: BoxFit.fill,
                      height: 25.w,
                    )
                },
              ),
              addHorizontalSpacing(10),
              Text(
                cloudVaultFile.file!.name.length < 30
                    ? cloudVaultFile.file!.name
                    : '${cloudVaultFile.file!.name.substring(0, 29)}...',
                style: kTextStyle(context: context, size: 12),
              ),
            ],
          ),
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: context.watch<ThemeProvider>().isDark
                ? Colors.white
                : Colors.black,
          ),
          onSelected: (value) {
            value == 'delete' ? deleteFile() : null;
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'delete',
                child: const Text("Delete"),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Text("Share"),
              )
            ];
          },
        ),
      ],
    );
  }
}
