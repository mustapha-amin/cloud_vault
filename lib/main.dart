import 'package:cloud_vault/providers/auth_provider.dart';
import 'package:cloud_vault/providers/auth_status_provider.dart';
import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/services/onboarding_pref.dart';
import 'package:cloud_vault/services/theme_prefs.dart';
import 'package:cloud_vault/utils/theme.dart';
import 'package:cloud_vault/views/screens/auth/authenticate.dart';
import 'package:cloud_vault/views/screens/auth/sign_up.dart';
import 'package:cloud_vault/views/screens/auth/wrapper.dart';
import 'package:cloud_vault/views/screens/onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'views/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ThemePreference.initThemeSettings();
  await OnboardingPreference.initOnboardingPrefs();
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
            home: OnboardingPreference.isFirstTime()
                ? const Onboarding()
                : const Wrapper(),
            theme: Apptheme.themeData(isDark, context),
          );
        },
      ),
    ),
  );
}
