import 'package:cloud_vault/utils/extensions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/textstyle.dart';

class FileDetailSheet extends StatelessWidget {
  const FileDetailSheet({
    super.key,
    required this.metaData,
  });

  final FullMetadata metaData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 20.h,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${metaData.name}",
              style: kTextStyle(context: context, size: 12),
            ),
            Text(
              "Size: ${metaData.size!.formatFileSize}",
              style: kTextStyle(context: context, size: 12),
            ),
            Text(
              "Date uploaded: ${metaData.timeCreated}",
              style: kTextStyle(context: context, size: 12),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: kTextStyle(
                    context: context,
                    size: 16,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
