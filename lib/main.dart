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
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:supermarket/core/services/local_database_service.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Localization (awaits loading of translation files)
  await EasyLocalization.ensureInitialized();

  // 3. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 4. Configure Firestore settings
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // 5. Configure Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 6. Initialize GetIt service locator
  await setupServiceLocator();
  //! 7. Debugging
  // LocalDatabaseService.deleteDatabaseFile();
  //* debugRepaintRainbowEnabled = true;
  // FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  runApp(
    EasyLocalization(
      path: AppPaths.translations,
      supportedLocales: LocalizationService.supportedLocales,
      fallbackLocale: LocalizationService.fallbackLocale,
      startLocale: LocalizationService.fallbackLocale,
      useOnlyLangCode: LocalizationService.useOnlyLangCode,
      saveLocale: LocalizationService.saveLocale,
      child: const MyApp(),
    ),
  );
}



  /*

  * navigate to home from login and register
  * complete the firebase auth datasource

  ? latest added is add-batch page and cubit, inventory bloc restock, update and remove

  next session: 
    1- migrate pagination to infinite scroll pagination package.
    2- start cashier screen



  */



/*
SQFLITE:

Windows 
Should work as is in debug mode (sqlite3.dll is bundled).

In release mode, add sqlite3.dll in same folder as your executable.

sqfliteFfiInit is provided as an implementation reference for loading the sqlite library. Please look at sqlite3 if you want to override the behavior.

 */

/*

cashier
inventory
stats
options

 */

/*

return SliverList.builder(
                  itemCount: state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.products.length) {
                      return context.read<InventoryBloc>().isFeedLastItemReached
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.products.isEmpty
                                    ? AppStrings.noProductsFoundHint
                                    : AppStrings.noMoreResults,
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                    }
                    return InventoryProductWidget(
                      product: state.products[index],
                      onEdit:
                          () => context.pushNamed(
                            AppRoutes.addItem,
                            arguments: state.products[index],
                          ),
                      onDelete:
                          () => context.dialog(
                            body: RemoveItemDialogBody(
                              onCancel: () => context.pop(),
                              onConfirm: () {
                                context.read<InventoryBloc>().add(
                                  InventoryRemoveItemEvent(
                                    state.products[index].id!,
                                  ),
                                );
                                context.pop();
                              },
                            ),
                          ),
                      onRestock:
                          () => context.pushNamed(
                            AppRoutes.addBatch,
                            arguments: state.products[index],
                          ),
                    );
                  },
                );

 */

/*

return SliverList.builder(
                  itemCount: state.searchedProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.searchedProducts.length) {
                      return context
                                  .read<InventoryBloc>()
                                  .isSearchLastItemReached ||
                              state.searchedProducts.isEmpty
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.searchedProducts.isEmpty
                                    ? AppStrings.noProductsFoundForQuery
                                    : AppStrings.noMoreResults,
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                    }
                    return InventoryProductWidget(
                      product: state.searchedProducts[index],
                      onEdit:
                          () => context.pushNamed(
                            AppRoutes.addItem,
                            arguments: state.searchedProducts[index],
                          ),
                      onDelete:
                          () => context.read<InventoryBloc>().add(
                            InventoryRemoveItemEvent(
                              state.searchedProducts[index].id!,
                            ),
                          ),
                      onRestock:
                          () => context.pushNamed(
                            AppRoutes.addBatch,
                            arguments: state.searchedProducts[index],
                          ),
                    );
                  },
                );


 */

