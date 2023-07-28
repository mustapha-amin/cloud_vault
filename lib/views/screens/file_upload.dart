// ignore_for_file: use_build_context_synchronously

import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../widgets/file_widget.dart';

class FileUpload extends StatefulWidget {
  final FilePickerResult pickedFile;
  final FileType fileType;
  const FileUpload({
    required this.pickedFile,
    required this.fileType,
    super.key,
  });

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  bool isLoading = false;
  PlatformFile? selectedFile;

  @override
  void initState() {
    selectedFile = widget.pickedFile.files.first;
    super.initState();
  }

  void upLoad(BuildContext context) async {
    var fileProvider = Provider.of<FileProvider>(context, listen: false);
    setState(() {
      isLoading = !isLoading;
    });

    for (var file in widget.pickedFile.files) {
      await DatabaseService().uploadFile(
          context,
          file,
          widget.fileType == FileType.custom
              ? "document"
              : widget.fileType.name,
          switch (widget.fileType) {
            FileType.image => fileProvider.newImageUploaded,
            FileType.video => fileProvider.newVideoUploaded,
            FileType.audio => fileProvider.newaudioUploaded,
            _ => fileProvider.newdocumentUploaded
          });
    }
    setState(() {
      isLoading = !isLoading;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<PlatformFile> files = widget.pickedFile.files;
    var fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload files"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      ...files.map(
                        (file) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFile = file;
                            });
                          },
                          child: FileWidget(
                            isSelected: file == selectedFile,
                            fileType: widget.fileType,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "Name: ${selectedFile!.name}",
              style: kTextStyle(context: context, size: 13),
            ),
            Text(
              "Size: ${selectedFile!.size.formatFileSize}",
              style: kTextStyle(context: context, size: 13),
            ),
            Text(
              "File format: ${selectedFile!.extension}",
              style: kTextStyle(context: context, size: 13),
            ),
            FilledButton.icon(
              onPressed: () {
                upLoad(context);
                fileProvider.toggleNewFileUploaded(switch (widget.fileType) {
                  FileType.image => fileProvider.newImageUploaded,
                  FileType.audio => fileProvider.newaudioUploaded,
                  FileType.video => fileProvider.newVideoUploaded,
                  _ => fileProvider.newdocumentUploaded,
                });
              },
              icon: isLoading
                  ? const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: const Text("Upload"),
            )
          ],
        ),
      ),
    );
  }
}

