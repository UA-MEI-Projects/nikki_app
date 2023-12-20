import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  final bool themeMode;
  final String userName;
  const SettingsData(this.themeMode, this.userName);
}

class NikkiSharedPreferences {
  static late SharedPreferences _preferences;

  static const _keyThemeMode = 'ThemeMode';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  Future setThemeMode(bool ThemeMode) async =>
      await _preferences.setBool(_keyThemeMode, ThemeMode);

  static bool getThemeMode() {
    bool? theme = _preferences.getBool(_keyThemeMode);
    if (theme == null) {
      return false;
    }
    return theme;
  }

  static SettingsData getSettingsData() {
    return SettingsData(getThemeMode(), 'userName');
  }
}
