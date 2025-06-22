import 'package:supermarket/data/datasource/settings_datasource.dart';
import 'package:supermarket/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDatasource _settingsDatasource;

  SettingsRepositoryImpl(this._settingsDatasource);

  @override
  Future<String?> getTheme() async {
    return await _settingsDatasource.getTheme();
  }

  @override
  Future<void> setTheme(String themeMode) async {
    await _settingsDatasource.setTheme(themeMode);
  }
}
