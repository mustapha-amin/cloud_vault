import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/theme_prefs.dart';
import 'package:cloud_vault/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'views/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemePreference.initThemeSettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          var isDark = Provider.of<ThemeProvider>(context).isDark;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Home(),
            theme: Apptheme.themeData(isDark, context),
          );
        },
      ),
    ),
  );
}
