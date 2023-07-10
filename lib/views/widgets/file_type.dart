import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class FileType extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;
  const FileType({
    required this.iconData,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          icon: const Icon(
            Icons.image_outlined,
            color: Colors.black,
          ),
          onPressed: () => onTap,
        ),
        Text(
          title,
          style: kTextStyle(context: context, size: 13),
        ),
      ],
    );
  }
}
