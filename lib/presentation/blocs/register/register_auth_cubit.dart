import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/error/failures.dart';
import 'package:supermarket/domain/repositories/auth_remote_repository.dart';
part 'package:supermarket/presentation/blocs/register/states/register_auth_state.dart';

class RegisterAuthCubit extends Cubit<RegisterAuthState> {
  final AuthRemoteRepository _authRemoteRepository;
  RegisterAuthCubit(this._authRemoteRepository) : super(RegisterAuthInitial());

  bool _isLoading = false;

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    if (_isLoading) return;
    emit(RegisterCredsLoading());
    _isLoading = true;

    try {
      await _authRemoteRepository.registerWithEmailAndPassword(
        email,
        password,
        name,
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure((e as Failure).message));
    }

    _isLoading = false;
  }

  Future<void> registerWithGoogle() async {
    if (_isLoading) return;
    emit(RegisterCredsLoading());
    _isLoading = true;

    try {
      await _authRemoteRepository.signInWithGoogle();
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure((e as Failure).message));
    }

    _isLoading = false;
  }
}
