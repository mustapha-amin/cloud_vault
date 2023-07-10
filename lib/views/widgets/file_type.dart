import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class FileType extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
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
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
          onPressed: onTap,
        ),
        Text(
          title,
          style: kTextStyle(context: context, size: 13),
        ),
      ],
    );
  }
}
