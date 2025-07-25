import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/error/failures.dart';
import 'package:supermarket/domain/repositories/auth_local_repository.dart';
import 'package:supermarket/domain/repositories/auth_remote_repository.dart';
part 'package:supermarket/presentation/blocs/login/states/login_auth_state.dart';

class LoginAuthCubit extends Cubit<LoginAuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  final AuthLocalRepository _authLocalRepository;
  LoginAuthCubit(this._authRemoteRepository, this._authLocalRepository)
    : super(LoginAuthInitial());

  bool _isLoading = false;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    if (_isLoading) return;
    emit(LoginCredsLoading());
    _isLoading = true;

    try {
      await _authRemoteRepository.loginWithEmailAndPassword(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure((e as Failure).message));
    }

    _isLoading = false;
  }

  Future<void> loginWithGoogle() async {
    if (_isLoading) return;
    emit(LoginGoogleLoading());
    _isLoading = true;

    try {
      await _authRemoteRepository.signInWithGoogle();
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure((e as Failure).message));
    }

    _isLoading = false;
  }

  Future<void> guestLogin() async {
    if (_isLoading) return;
    emit(LoginGuestLoading());
    _isLoading = true;

    try {
      await _authLocalRepository.setIsGuest(true);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure((e as Failure).message));
    }

    _isLoading = false;
  }
}
