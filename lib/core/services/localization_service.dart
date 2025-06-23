import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:supermarket/core/services/navigation_service.dart';

class LocalizationService {
  final NavigationService navigationService;
  LocalizationService(this.navigationService);

  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  static final Locale fallbackLocale = const Locale('ar');

  static final bool useOnlyLangCode = true;

  static final bool saveLocale = true;

  Locale getLocale() {
    return navigationService.navigatorKey.currentContext?.locale ??
        supportedLocales.first;
  }

  Locale switchLocale() {
    final currentLocale = getLocale();
    final currentIndex = supportedLocales.indexOf(currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    final nextLocale = supportedLocales[nextIndex];

    EasyLocalization.of(
      navigationService.navigatorKey.currentContext!,
    )!.setLocale(nextLocale);

    return nextLocale;
  }

  Locale setLocale(Locale locale) {
    EasyLocalization.of(
      navigationService.navigatorKey.currentContext!,
    )!.setLocale(locale);

    return locale;
  }
}


/*

    void _toggleLanguage() {
      final currentIndex = supportedLocales.indexOf(currentLocale);

      final nextIndex = (currentIndex + 1) % supportedLocales.length;

      final nextLocale = supportedLocales[nextIndex];
      context.read<LanguageCubit>().changeLanguage(context, nextLocale);
    }

 */