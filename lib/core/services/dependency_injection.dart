import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supermarket/core/services/localization_service.dart";
import "package:supermarket/core/services/navigation_service.dart";
import "package:supermarket/data/datasource/auth_datasource.dart";
import "package:supermarket/data/datasource/settings_datasource.dart";
import "package:supermarket/data/repositories/auth_repository_impl.dart";
import "package:supermarket/data/repositories/settings_repository_impl.dart";
import "package:supermarket/domain/repositories/auth_repository.dart";
import "package:supermarket/domain/repositories/settings_repository.dart";
import "package:supermarket/presentation/blocs/boarding/boarding_navigation_cubit.dart";
import "package:supermarket/presentation/blocs/localization/localization_cubit.dart";
import "package:supermarket/presentation/blocs/register/register_auth_bloc.dart";
import "package:supermarket/presentation/blocs/register/register_ui_cubit.dart";
import "package:supermarket/presentation/blocs/splash/splash_navigation_bloc.dart";
import "package:supermarket/presentation/blocs/theme/theme_cubit.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  const AndroidOptions androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  const secureStorage = FlutterSecureStorage(aOptions: androidOptions);

  // ####################
  //* ## EXTERNAL LIBS
  // ####################
  serviceLocator.registerSingletonAsync(
    () async => await SharedPreferences.getInstance(),
  );
  serviceLocator.registerSingleton<FlutterSecureStorage>(secureStorage);

  // ####################
  //* ## Services
  // ####################
  serviceLocator.registerLazySingleton(() => NavigationService());
  serviceLocator.registerLazySingleton(
    () => LocalizationService(serviceLocator()),
  );

  // ####################
  //* ## Data Sources
  // ####################
  serviceLocator.registerLazySingleton(
    () => SettingsDatasource(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthDatasource(serviceLocator(), serviceLocator()),
  );

  // ####################
  //* ## Repositories
  // ####################
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  // ####################
  //* ## Blocs & Cubits
  // ####################
  serviceLocator.registerLazySingleton(() => ThemeCubit(serviceLocator()));
  serviceLocator.registerFactory(() => LocalizationCubit(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => SplashNavigationBloc(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => BoardingNavigationCubit());
  serviceLocator.registerFactory(() => RegisterUiCubit());
  serviceLocator.registerFactory(() => RegisterAuthBloc());
}
