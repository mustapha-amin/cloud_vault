import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/spacings.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/screens/auth/verify_email.dart';
import 'package:cloud_vault/views/widgets/drawer.dart';
import 'package:cloud_vault/views/widgets/file_tile.dart';
import 'package:cloud_vault/views/widgets/file_types.dart';
import 'package:cloud_vault/views/widgets/storage_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
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
            const FileTile(iconData: Icons.image, title: "Images"),
            const FileTile(iconData: Icons.video_collection, title: "Videos"),
            const FileTile(iconData: Icons.audio_file, title: "Audios"),
            const FileTile(iconData: Icons.file_copy, title: "Documents"),
            addVerticalSpacing(10.h),
            const StorageInfo()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: theme.isDark
                ? const Color.fromARGB(255, 46, 47, 50)
                : Colors.white,
            context: context,
            builder: (context) {
              return SizedBox(
                height: 45.h,
                width: 100.w,
                child: const FileTypes(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
