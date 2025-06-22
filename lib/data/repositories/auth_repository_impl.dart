import 'package:supermarket/data/datasource/auth_datasource.dart';
import 'package:supermarket/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;
  AuthRepositoryImpl(this._authDatasource);

  @override
  Future<void> setIsFirstTime() async {
    return await _authDatasource.setIsFirstTime();
  }

  @override
  bool? getIsFirstTime() {
    return _authDatasource.getIsFirstTime();
  }

  @override
  Future<void> saveFirebaseToken(String token) async {
    return await _authDatasource.saveFirebaseToken(token);
  }

  @override
  Future<String?> getFirebaseToken() async {
    return await _authDatasource.getFirebaseToken();
  }
}
