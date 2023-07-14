import 'package:flutter/material.dart';

void showDeletionDialog(
  BuildContext context, {
  Future<void> Function()? delete,
  String? title,
  String? content,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title!),
        content: Text(content!),
        actions: [
          TextButton(
              onPressed: () {
                delete!.call();
                Navigator.of(context).pop();
              },
              child: const Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"))
        ],
      );
    },
  );
}
