import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/repositories/auth_repository.dart';

class SplashNavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final AuthRepository _authRepository;
  SplashNavigationBloc(this._authRepository) : super(Initial()) {
    on<CheckAuth>((event, emit) async {
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

class NavigationEvent {}

class CheckAuth extends NavigationEvent {}

class NavigationState {}

class Initial extends NavigationState {}

class Loading extends NavigationState {}

class FirstTimeUse extends NavigationState {}

class Authenticated extends NavigationState {}

class Unauthenticated extends NavigationState {}
