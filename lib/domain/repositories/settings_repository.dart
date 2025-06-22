abstract interface class SettingsRepository {
  Future<String?> getTheme();
  Future<void> setTheme(String themeMode);
}
