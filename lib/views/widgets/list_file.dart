import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../models/cloudvaultfile.dart';
import '../../providers/files_provider.dart';
import '../../utils/spacings.dart';
import '../../utils/textstyle.dart';
import 'future_network_image.dart';

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
          padding: const EdgeInsets.all(10.0),
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
      ],
    );
  }
}
