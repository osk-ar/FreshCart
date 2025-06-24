import 'package:supermarket/data/datasource/local/auth_local_datasource.dart';
import 'package:supermarket/domain/repositories/auth_local_repository.dart';

class AuthLocalRepositoryImpl implements AuthLocalRepository {
  final AuthLocalDatasource _authDatasource;
  AuthLocalRepositoryImpl(this._authDatasource);

  @override
  Future<void> setIsFirstTime() async {
    return await _authDatasource.setIsFirstTime();
  }

  @override
  bool? getIsFirstTime() {
    return _authDatasource.getIsFirstTime();
  }
}
