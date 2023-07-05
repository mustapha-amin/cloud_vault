import 'package:cloud_vault/utils/navigate_to.dart';
import 'package:cloud_vault/views/screens/file_contents.dart';
import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class FileTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  const FileTile({required this.iconData, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateTo(context, FileContents(title: title));
      },
      child: ListTile(
        leading: Icon(iconData),
        title: Text(
          title,
          style: kTextStyle(context: context, size: 15),
        ),
      ),
    );
  }
}
