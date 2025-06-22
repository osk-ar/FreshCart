import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/repositories/settings_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepository _settingsRepository;
  ThemeCubit(this._settingsRepository) : super(ThemeMode.system);

  Future<void> loadTheme() async {
    final themeString = await _settingsRepository.getTheme();

    switch (themeString) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
    }
  }

  void setTheme(ThemeMode themeMode) {
    _settingsRepository.setTheme(themeMode.name);
    emit(themeMode);
  }
}
