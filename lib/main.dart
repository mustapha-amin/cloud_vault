import 'package:cloud_vault/providers/theme_provider.dart';
import 'package:cloud_vault/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Builder(builder: (context) {
        var theme = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          home: const Home(),
          theme: Apptheme.themeData(theme.isDark, context),
        );
      }),
    ),
  );
}
