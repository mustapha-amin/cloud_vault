import 'package:cloud_vault/providers/auth_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/auth_constants.dart';
import 'package:cloud_vault/utils/textstyle.dart';
import 'package:cloud_vault/views/widgets/storage_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: 85.w,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("John Doe"),
            accountEmail: Text(AuthConstants.user!.email!),
          ),
          SwitchListTile(
            title: Text(
              themeProvider.isDark ? "Dark mode" : "Light mode",
              style: kTextStyle(context: context, size: 15),
            ),
            value: themeProvider.isDark,
            onChanged: (_) => themeProvider.toggleTheme(),
            thumbIcon: MaterialStatePropertyAll(
              Icon(
                themeProvider.isDark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Log out",
              style: kTextStyle(context: context, size: 15),
            ),
            trailing: Icon(
              Icons.logout,
              color: themeProvider.isDark ? Colors.white : Colors.black,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Log out"),
                      content: const Text("Do you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<AuthProvider>().signOut();
                            Navigator.of(context).pop();
                          },
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No"),
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
