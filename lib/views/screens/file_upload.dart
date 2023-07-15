import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/extensions.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void upLoad(BuildContext context) async {
    setState(() {
      isLoading = !isLoading;
    });

    for (var file in widget.pickedFile.files) {
      await DatabaseService().uploadFile(
          context,
          file,
          widget.fileType == FileType.custom
              ? "document"
              : widget.fileType.name);
    }
    setState(() {
      isLoading = !isLoading;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Uploaded successfully"),
      margin: EdgeInsets.all(6),
      duration: Duration(milliseconds: 900),
      behavior: SnackBarBehavior.floating,
    ));
    await Future.delayed(const Duration(milliseconds: 900));
    ScaffoldMessenger.of(context).clearSnackBars();
    // ignore: use_build_context_synchronously
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
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isSelected
            ? Border.all(
                width: 3,
                color: Theme.of(context).primaryColor,
              )
            : Border.all(
                width: 0.2,
                color: context.watch<ThemeProvider>().isDark
                    ? Colors.grey[300]!
                    : Colors.grey[800]!,
              ),
      ),
      child: Icon(
        fileType == FileType.image
            ? Icons.image
            : fileType == FileType.video
                ? Icons.video_collection
                : fileType == FileType.audio
                    ? Icons.audio_file
                    : Icons.file_copy,
        color:
            context.watch<ThemeProvider>().isDark ? Colors.grey : Colors.black,
      ),
    );
  }
}
