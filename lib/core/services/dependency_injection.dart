import "package:get_it/get_it.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supermarket/core/services/localization_service.dart";
import "package:supermarket/core/services/memory_cache_service.dart";
import "package:supermarket/core/services/navigation_service.dart";
import "package:supermarket/data/datasource/local/auth_local_datasource.dart";
import "package:supermarket/data/datasource/local/settings_local_datasource.dart";
import "package:supermarket/data/datasource/remote/auth_remote_datasource.dart";
import "package:supermarket/data/repositories/auth_local_repository_impl.dart";
import "package:supermarket/data/repositories/auth_remote_repository_impl.dart";
import "package:supermarket/data/repositories/settings_repository_impl.dart";
import "package:supermarket/domain/repositories/auth_local_repository.dart";
import "package:supermarket/domain/repositories/auth_remote_repository.dart";
import "package:supermarket/domain/repositories/settings_repository.dart";
import "package:supermarket/presentation/blocs/boarding/boarding_navigation_cubit.dart";
import "package:supermarket/presentation/blocs/localization/localization_cubit.dart";
import "package:supermarket/presentation/blocs/login/login_auth_cubit.dart";
import "package:supermarket/presentation/blocs/login/login_ui_cubit.dart";
import "package:supermarket/presentation/blocs/register/register_auth_cubit.dart";
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
  serviceLocator.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());

  // ####################
  //* ## Services
  // ####################
  serviceLocator.registerLazySingleton(() => NavigationService());
  serviceLocator.registerLazySingleton(
    () => LocalizationService(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => MemoryCacheService());

  // ####################
  //* ## Data Sources
  // ####################
  serviceLocator.registerLazySingleton(
    () => SettingsLocalDatasource(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthLocalDatasource(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AuthRemoteDatasource(serviceLocator()),
  );

  // ####################
  //* ## Repositories
  // ####################
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepositoryImpl(serviceLocator(), serviceLocator()),
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
  serviceLocator.registerFactory(() => RegisterAuthCubit(serviceLocator()));

  serviceLocator.registerFactory(() => LoginUiCubit());
  serviceLocator.registerFactory(() => LoginAuthCubit(serviceLocator()));
}
