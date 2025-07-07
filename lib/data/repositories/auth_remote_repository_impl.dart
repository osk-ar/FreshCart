import 'package:supermarket/core/constants/app_keys.dart';
import 'package:supermarket/core/services/memory_cache_service.dart';
import 'package:supermarket/data/datasource/remote/auth_remote_datasource.dart';
import 'package:supermarket/domain/entities/app_user_entity.dart';
import 'package:supermarket/domain/repositories/auth_remote_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRemoteRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final MemoryCacheService _memoryCacheService;

  AuthRemoteRepositoryImpl(
    this._authRemoteDatasource,
    this._memoryCacheService,
  );

  @override
  Future<AppUser?> signInWithGoogle() async {
    final user = await _authRemoteDatasource.signInWithGoogle();

    _memoryCacheService.set<AppUser?>(AppKeys.userCache, user);

    return user;
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final user = await _authRemoteDatasource.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );

    _memoryCacheService.set<AppUser?>(AppKeys.userCache, user);

    return user;
  }

  @override
  Future<AppUser?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final user = await _authRemoteDatasource.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    _memoryCacheService.set<AppUser?>(AppKeys.userCache, user);

    return user;
  }

  Future<AppUser?> getUserData() async {
    final cachedUser = _memoryCacheService.get<AppUser?>(AppKeys.userCache);

    return cachedUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _authRemoteDatasource.isAuthenticated();
  }

  @override
  Future<void> signOut() async {
    await _authRemoteDatasource.signOut();
    _memoryCacheService.invalidate(AppKeys.userCache);
  }
}
