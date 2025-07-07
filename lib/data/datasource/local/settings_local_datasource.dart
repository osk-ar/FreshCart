import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket/core/constants/app_keys.dart';

class SettingsLocalDatasource {
  final SharedPreferences _preferences;
  SettingsLocalDatasource(this._preferences);

  Future<void> setTheme(String theme) async {
    await _preferences.setString(AppKeys.themeMode, theme);
  }

  Future<String?> getTheme() async {
    return _preferences.getString(AppKeys.themeMode);
  }
}
