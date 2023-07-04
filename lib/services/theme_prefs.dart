import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static SharedPreferences? themePrefs;

  static initThemeSettings() async {
    themePrefs = await SharedPreferences.getInstance();
  }

  static bool isDark() {
    return themePrefs!.getBool('themeMode') ?? false;
  }

  static saveTheme(bool mode) async {
    await themePrefs!.setBool('themeMode', mode);
  }
}
