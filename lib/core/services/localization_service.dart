import 'dart:ui';

class LocalizationService {
  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  static final Locale fallbackLocale = const Locale('en');

  static final bool useOnlyLangCode = true;

  static final bool saveLocale = true;
}
