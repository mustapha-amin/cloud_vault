import 'package:shared_preferences/shared_preferences.dart';

class FileDisplayPreference {
  static SharedPreferences? displayPreferences;

  static init() async {
    displayPreferences = await SharedPreferences.getInstance();
  }

  static bool isGrid() {
    return displayPreferences!.getBool('isGrid') ?? true;
  }

  static toggle(bool val) async {
    await displayPreferences!.setBool('isGrid', val);
  }
}
