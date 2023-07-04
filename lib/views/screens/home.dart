import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/widgets/custom_tile.dart';
import 'package:cloud_vault/views/widgets/file_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cloud vault",
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Switch(
              thumbIcon: MaterialStatePropertyAll(
                Icon(
                  theme.isDark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
              ),
              value: theme.isDark,
              onChanged: (_) => theme.toggleTheme(),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
        child: ListView(
          children: const [
            CustomTile(iconData: Icons.image, text: "Images"),
            CustomTile(iconData: Icons.video_collection, text: "Videos"),
            CustomTile(iconData: Icons.audio_file, text: "Audios"),
            CustomTile(iconData: Icons.file_copy, text: "Documents"),
            
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
