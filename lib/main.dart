import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/app.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/core/services/localization_service.dart';
import 'package:supermarket/firebase_options.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Localization (awaits loading of translation files)
  await EasyLocalization.ensureInitialized();

  // 3. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 4. Configure Firestore settings
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enable offline persistence
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Use unlimited cache size
  );

  // 5. Configure Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 5. Initialize GetIt service locator
  await setupServiceLocator();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationService.supportedLocales,
      path: AppPaths.translations,
      fallbackLocale: LocalizationService.fallbackLocale,
      useOnlyLangCode: LocalizationService.useOnlyLangCode,
      saveLocale: LocalizationService.saveLocale,
      child: const MyApp(),
    ),
  );
}



/*
  1- Boarding is not complete





 */