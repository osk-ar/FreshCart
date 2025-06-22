import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket/core/constants/app_keys.dart';

class AuthDatasource {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;
  AuthDatasource(this._secureStorage, this._sharedPreferences);

  bool? getIsFirstTime() {
    return _sharedPreferences.getBool(AppKeys.isFirstTime);
  }

  Future<void> setIsFirstTime() async {
    await _sharedPreferences.setBool(AppKeys.isFirstTime, false);
  }

  Future<void> saveFirebaseToken(String token) async {
    await _secureStorage.write(key: AppKeys.firebaseToken, value: token);
  }

  Future<String?> getFirebaseToken() async {
    return await _secureStorage.read(key: AppKeys.firebaseToken);
  }
}
