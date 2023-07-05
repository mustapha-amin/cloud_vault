import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/textstyle.dart';

class StorageInfo extends StatelessWidget {
  const StorageInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.8,
          color: Colors.grey[500]!,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          Icons.cloud_done,
          size: 40.sp,
        ),
        title: Text(
          "Storage",
          style: kTextStyle(
            context: context,
            size: 17,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: 0.3,
              backgroundColor: theme.isDark ? Colors.white : Colors.grey[400],
            ),
            Text(
              "300MB used / 1GB free",
              style: kTextStyle(context: context, size: 13),
            )
          ],
        ),
      ),
    );
  }
}
