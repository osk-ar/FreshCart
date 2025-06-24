abstract interface class AuthLocalRepository {
  Future<void> setIsFirstTime();
  bool? getIsFirstTime();
}
