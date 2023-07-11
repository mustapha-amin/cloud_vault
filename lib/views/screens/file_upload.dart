import 'dart:io';

import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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

  void upLoad() async {
    setState(() {
      isLoading = !isLoading;
    });
    for (var file in widget.pickedFile.files) {
      await DatabaseService().uploadFile(context, file, widget.fileType.name);
    }
    setState(() {
      isLoading = !isLoading;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    List<PlatformFile> files = widget.pickedFile.files;
    return Scaffold(
      appBar: AppBar(
        title: const Text("File detail"),
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
            Text("Name: ${selectedFile!.name}"),
            Text("Size: ${selectedFile!.size.formatFileSize}"),
            Text("File format: ${selectedFile!.extension}"),
            FilledButton.icon(
              onPressed: () {
                upLoad();
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

class FileWidget extends StatelessWidget {
  bool isSelected;
  FileType fileType;

  FileWidget({
    required this.isSelected,
    required this.fileType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(
                width: 0.7,
                color: Theme.of(context).primaryColor,
              )
            : null,
      ),
      child: Icon(
        fileType == FileType.image
            ? Icons.image
            : fileType == FileType.video
                ? Icons.video_collection
                : fileType == FileType.audio
                    ? Icons.audio_file
                    : Icons.file_copy,
      ),
    );
  }
}
