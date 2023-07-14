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
                'images' => Image.network(
                    cloudVaultFile.url!,
                    fit: BoxFit.cover,
                    width: 25.w,
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
        Positioned(
          top: 2,
          right: 2,
          child: PopupMenuButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: context.watch<ThemeProvider>().isDark
                  ? Colors.white
                  : Colors.black,
            ),
            itemBuilder: (context) {
              return [];
            },
          ),
        )
      ],
    );
  }
}
