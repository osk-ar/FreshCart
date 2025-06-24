import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket/core/constants/app_keys.dart';

class AuthLocalDatasource {
  final SharedPreferences _sharedPreferences;
  AuthLocalDatasource(this._sharedPreferences);

  bool? getIsFirstTime() {
    return _sharedPreferences.getBool(AppKeys.isFirstTime);
  }

  Future<void> setIsFirstTime() async {
    await _sharedPreferences.setBool(AppKeys.isFirstTime, false);
  }
}
