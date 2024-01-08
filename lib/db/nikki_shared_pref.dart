import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  final bool themeMode;
  final String userName;
  const SettingsData(this.themeMode, this.userName);
}

class NikkiSharedPreferences {
   late SharedPreferences _preferences;

   final _keyThemeMode = 'ThemeMode';
   final _keyUsername = 'Username';
   final _keyPrompt = 'Prompt';

   Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  Future setThemeMode(bool ThemeMode) async =>
      await _preferences.setBool(_keyThemeMode, ThemeMode);

   bool getThemeMode() {
    bool? theme = _preferences.getBool(_keyThemeMode);
    if (theme == null) {
      return false;
    }
    return theme;
  }

  Future setPrompt(String prompt) async =>
      await _preferences.setString(_keyPrompt, prompt);

   String getPrompt(){
     String? username = _preferences.getString(_keyPrompt);
     if (username == null) {
       return "";
     }
     return username;
   }

  Future setUsername(String username) async =>
    await _preferences.setString(_keyUsername, username);

   String getUsername() {
     String? username = _preferences.getString(_keyUsername);
     if (username == null) {
       return "";
     }
     return username;
   }

   SettingsData getSettingsData() {
    return SettingsData(getThemeMode(), 'userName');
  }
}
