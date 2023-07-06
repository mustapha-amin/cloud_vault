import 'package:cloud_vault/providers/auth_provider.dart';
import 'package:cloud_vault/providers/auth_status_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/theme_prefs.dart';
import 'package:cloud_vault/utils/theme.dart';
import 'package:cloud_vault/views/screens/auth/authenticate.dart';
import 'package:cloud_vault/views/screens/auth/sign_up.dart';
import 'package:cloud_vault/views/screens/onboarding/onboarding.dart';
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
        ChangeNotifierProvider(
          create: (_) => AuthStatusProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, _, __) {
          var isDark = Provider.of<ThemeProvider>(context).isDark;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const Onboarding(),
            theme: Apptheme.themeData(isDark, context),
          );
        },
      ),
    ),
  );
}
