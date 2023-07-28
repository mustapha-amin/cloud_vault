import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/theme_provider.dart';

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
