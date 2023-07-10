import 'package:cloud_vault/views/widgets/file_type.dart';
import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class FileTypesModalSheet extends StatelessWidget {
  const FileTypesModalSheet({super.key});

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
            FileType(
              iconData: Icons.image,
              title: "Image",
              onTap: () {},
            ),
            FileType(
              iconData: Icons.video_collection_outlined,
              title: "Video",
              onTap: () {},
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FileType(
              iconData: Icons.audio_file_outlined,
              title: "Audio",
              onTap: () {},
            ),
            FileType(
              iconData: Icons.file_copy_outlined,
              title: "Document",
              onTap: () {},
            )
          ],
        ),
      ],
    );
  }
}
