import 'package:supermarket/core/constants/app_keys.dart';
import 'package:supermarket/core/services/memory_cache_service.dart';
import 'package:supermarket/data/datasource/local/auth_local_datasource.dart';
import 'package:supermarket/domain/repositories/auth_local_repository.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDatasource _authDatasource;
  final MemoryCacheService _memoryCacheService;
  AuthLocalRepositoryImpl(this._authDatasource, this._memoryCacheService);

  @override
  Future<void> setIsFirstTime() async {
    return await _authDatasource.setIsFirstTime();
  }

  @override
  bool getIsFirstTime() {
    return _authDatasource.getIsFirstTime() ?? true;
  }

  @override
  Future<void> setIsGuest(bool isGuest) async {
    await _authDatasource.setIsGuest(isGuest.toString());

    _memoryCacheService.set(AppKeys.isGuestCache, isGuest);
  }

  @override
  Future<bool> getIsGuest() async {
    final bool? cachedIsGuest = _memoryCacheService.get(AppKeys.isGuestCache);
    if (cachedIsGuest != null) return cachedIsGuest;

    final String? isGuest = await _authDatasource.getIsGuest();

    return isGuest != null ? bool.parse(isGuest) : false;
  }

  @override
  Future<bool> checkPIN(String pin) async {
    final correctPIN = await _authDatasource.getPin();

    return correctPIN == pin;
  }

  @override
  Future<void> setPIN(String pin) async {
    await _authDatasource.setPIN(pin);
  }

  @override
  Future<bool> pinExist() async {
    return await _authDatasource.getPin() != null;
  }
}
