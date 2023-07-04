import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

class CustomTile extends StatelessWidget {
  final IconData iconData;
  final String text;
  const CustomTile({required this.iconData, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(
        text,
        style: kTextStyle(context: context, size: 15),
      ),
    );
  }
}
