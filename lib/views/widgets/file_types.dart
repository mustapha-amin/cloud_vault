import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class FileTypes extends StatelessWidget {
  const FileTypes({super.key});

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
            Column(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(
                    Icons.image_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                Text(
                  "Image",
                  style: kTextStyle(context: context, size: 13),
                ),
              ],
            ),
            Column(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(
                    Icons.video_collection_outlined,
                    color: Colors.black,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                Text(
                  "video",
                  style: kTextStyle(context: context, size: 13),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(
                    Icons.audio_file_outlined,
                    color: Colors.black,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                Text(
                  "Audio",
                  style: kTextStyle(context: context, size: 13),
                ),
              ],
            ),
            Column(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(
                    Icons.file_copy_outlined,
                    color: Colors.black,
                  ),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                Text(
                  "Document",
                  style: kTextStyle(context: context, size: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
