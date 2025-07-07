import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/localization_service.dart';

class LocalizationCubit extends Cubit<Locale> {
  final LocalizationService localizationService;
  LocalizationCubit(this.localizationService)
    : super(localizationService.getLocale());

  void switchLocale() {
    final newLocale = localizationService.switchLocale();
    emit(newLocale);
  }
}
