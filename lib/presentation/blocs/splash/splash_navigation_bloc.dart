import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/repositories/auth_repository.dart';

part 'package:supermarket/presentation/blocs/splash/events/splash_navigation_event.dart';
part 'package:supermarket/presentation/blocs/splash/states/splash_navigation_state.dart';

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
