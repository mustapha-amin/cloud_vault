import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreference {
  static SharedPreferences? themePrefs;

  static initOnboardingPrefs() async {
    themePrefs = await SharedPreferences.getInstance();
  }

  static bool isFirstTime() {
    return themePrefs!.getBool('firstTime') ?? true;
  }

  static savePref(bool value) async {
    await themePrefs!.setBool('firstTime', value);
  }
}
