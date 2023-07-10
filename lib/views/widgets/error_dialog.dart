import 'package:flutter/material.dart';

import '../../utils/textstyle.dart';

void showErrorDialog(BuildContext context, String? text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actionsAlignment: MainAxisAlignment.end,
        content: Text(
          text!,
          style: kTextStyle(context: context, size: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Ok",
              style: kTextStyle(context: context, size: 12),
            ),
          )
        ],
      );
    },
  );
}
