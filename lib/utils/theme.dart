import 'package:cloud_vault/utils/textstyle.dart';
import 'package:flutter/material.dart';

class Apptheme {
  static ThemeData themeData(bool isDark, BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        titleTextStyle: kTextStyle(
          context: context,
          size: 18,
        ),
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}
