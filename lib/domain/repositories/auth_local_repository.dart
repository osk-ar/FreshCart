abstract interface class AuthLocalRepository {
  Future<void> setIsFirstTime();
  bool getIsFirstTime();

  Future<void> setIsGuest(bool isGuest);
  Future<bool> getIsGuest();

  Future<void> setPIN(String pin);
  Future<bool> checkPIN(String pin);
  Future<bool> pinExist();
}
