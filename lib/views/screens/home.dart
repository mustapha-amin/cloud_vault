import 'dart:developer';

import 'package:cloud_vault/providers/files_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/screens/auth/verify_email.dart';
import 'package:cloud_vault/views/widgets/drawer.dart';
import 'package:cloud_vault/views/widgets/file_tile.dart';
import 'package:cloud_vault/views/widgets/file_types_modalsheet.dart';
import 'package:cloud_vault/views/widgets/storage_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: Text(
          "Cloud vault",
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        child: ListView(
          children: [
            FileTile(
              iconData: Icons.image,
              title: "Images",
              cloudVaultFiles: fileProvider.images,
            ),
            FileTile(
              iconData: Icons.video_collection,
              title: "Videos",
              cloudVaultFiles: fileProvider.videos,
            ),
            FileTile(
              iconData: Icons.audio_file,
              title: "Audios",
              cloudVaultFiles: fileProvider.audios,
            ),
            FileTile(
              iconData: Icons.file_copy,
              title: "Documents",
              cloudVaultFiles: fileProvider.documents,
            ),
            addVerticalSpacing(10.h),
            const StorageInfo()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log(AuthConstants.userId!);
          showModalBottomSheet(
            backgroundColor: theme.isDark
                ? const Color.fromARGB(255, 46, 47, 50)
                : Colors.white,
            context: context,
            builder: (context) {
              return SizedBox(
                height: 45.h,
                width: 100.w,
                child: const FileTypesModalSheet(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
