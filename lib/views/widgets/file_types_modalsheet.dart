// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/views/screens/file_upload.dart';
import 'package:cloud_vault/views/widgets/file_type.dart' as k;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../utils/textstyle.dart';

class FileTypesModalSheet extends StatefulWidget {
  const FileTypesModalSheet({super.key});

  @override
  State<FileTypesModalSheet> createState() => _FileTypesModalSheetState();
}

class _FileTypesModalSheetState extends State<FileTypesModalSheet> {
  FilePicker filePicker = FilePicker.platform;

  Future<void> pickFile(FileType fileType, {bool? isAudio}) async {
    isAudio ??= false;
    FilePickerResult? result = await filePicker.pickFiles(
      type: isAudio ? FileType.audio : fileType,
      allowMultiple: true,
      allowedExtensions:
          fileType == FileType.custom ? ['pdf', 'doc', 'docx'] : null,
    );

    if (result != null) {
      navigateTo(
          context,
          FileUpload(
            pickedFile: result,
            fileType: isAudio ? FileType.audio : fileType,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Select a file type to upload",
          style: kTextStyle(context: context, size: 15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            k.FileType(
              iconData: Icons.image,
              title: "Image",
              onTap: () => pickFile(FileType.image),
            ),
            k.FileType(
              iconData: Icons.video_collection_outlined,
              title: "Video",
              onTap: () => pickFile(FileType.video),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            k.FileType(
              iconData: Icons.audio_file_outlined,
              title: "Audio",
              onTap: () => pickFile(FileType.any, isAudio: true),
            ),
            k.FileType(
              iconData: Icons.file_copy_outlined,
              title: "Document",
              onTap: () => pickFile(FileType.custom),
            )
          ],
        ),
      ],
    );
  }
}
