import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket/core/constants/app_keys.dart';

class AuthLocalDatasource {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;
  AuthLocalDatasource(this._sharedPreferences, this._secureStorage);

  bool? getIsFirstTime() {
    return _sharedPreferences.getBool(AppKeys.isFirstTime);
  }

  Future<void> setIsFirstTime() async {
    await _sharedPreferences.setBool(AppKeys.isFirstTime, false);
  }

  Future<String?> getIsGuest() async {
    return await _secureStorage.read(key: AppKeys.isGuest);
  }

  Future<void> setIsGuest(String isGuest) async {
    await _secureStorage.write(key: AppKeys.isGuest, value: isGuest);
  }

  Future<String?> getPin() async {
    return await _secureStorage.read(key: AppKeys.isGuest);
  }

  Future<void> setPIN(String pin) async {
    await _secureStorage.write(key: AppKeys.pin, value: pin);
  }
}

// is_guest
// save and check PIN
