import 'package:cloud_vault/services/database.dart';
import 'package:cloud_vault/utils/navigations.dart';
import 'package:cloud_vault/views/screens/file_contents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cloudvaultfile.dart';
import '../../providers/files_provider.dart';
import '../../utils/textstyle.dart';

class FileTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final List<CLoudVaultFile> cloudVaultFiles;

  const FileTile({
    required this.iconData,
    required this.title,
    required this.cloudVaultFiles,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var filesProvider = Provider.of<FileProvider>(context);
    return GestureDetector(
      onTap: () {
        filesProvider.loadFiles(
          cloudVaultFiles,
          title.toLowerCase(),
        );
        navigateTo(
          context,
          FileContents(
            title: title.toLowerCase(),
            iconData: iconData,
            cloudVaultFiles: cloudVaultFiles,
          ),
        );
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
