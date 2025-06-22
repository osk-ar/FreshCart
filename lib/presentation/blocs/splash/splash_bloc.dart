import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/repositories/auth_repository.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository _authRepository;
  SplashBloc(this._authRepository) : super(Initial()) {
    on<SplashCheckAuth>((event, emit) async {
      emit(Loading());

      final isFirstTime = _authRepository.getIsFirstTime();
      if (isFirstTime ?? true) {
        emit(FirstTimeUse());
        //todo uncomment this line
        // await _authRepository.setIsFirstTime();
        return;
      }

      final token = await _authRepository.getFirebaseToken();
      if (token != null && token.isNotEmpty) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });
  }
}

class SplashEvent {}

class SplashCheckAuth extends SplashEvent {}

class SplashState {}

class Initial extends SplashState {}

class Loading extends SplashState {}

class FirstTimeUse extends SplashState {}

class Authenticated extends SplashState {}

class Unauthenticated extends SplashState {}
