import 'dart:developer';

import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/views/widgets/future_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/cloudvaultfile.dart';
import '../../providers/theme_provider.dart';
import '../../utils/textstyle.dart';

class GridFile extends StatelessWidget {
  final CLoudVaultFile cloudVaultFile;
  final String fileType;
  String? extension;

  GridFile({
    super.key,
    required this.cloudVaultFile,
    required this.fileType,
    this.extension,
  });

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

    return Stack(
      children: [
        Container(
          height: 40.h,
          width: 50.w,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 0.3,
              ),
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 0.3,
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                  child: switch (fileType) {
                'images' => FutureNetWorkImage(
                    imgUrl: cloudVaultFile.url!,
                    width: 25.w,
                    fit: BoxFit.cover,
                  ),
                'audios' => const Icon(Icons.audiotrack),
                'videos' => const Icon(Icons.video_collection),
                _ => Image.asset(
                    extension == 'pdf'
                        ? 'assets/images/pdf.png'
                        : extension == 'docx'
                            ? 'assets/images/word.png'
                            : 'assets/images/pptx-file.png',
                    width: 25.w,
                  )
              }),
              Text(
                cloudVaultFile.file!.name,
                style: kTextStyle(context: context, size: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
