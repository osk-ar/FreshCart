abstract interface class AuthRepository {
  Future<void> setIsFirstTime();
  bool? getIsFirstTime();
  Future<void> saveFirebaseToken(String token);
  Future<String?> getFirebaseToken();
}
