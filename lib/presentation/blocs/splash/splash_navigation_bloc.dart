import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/repositories/auth_local_repository.dart';
import 'package:supermarket/domain/repositories/auth_remote_repository.dart';

part 'package:supermarket/presentation/blocs/splash/events/splash_navigation_event.dart';
part 'package:supermarket/presentation/blocs/splash/states/splash_navigation_state.dart';

class SplashNavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final AuthLocalRepository _authLocalRepository;
  final AuthRemoteRepository _authRemoteRepository;
  SplashNavigationBloc(this._authLocalRepository, this._authRemoteRepository)
    : super(Initial()) {
    on<CheckAuth>((event, emit) async {
      emit(Loading());

      final isFirstTime = _authLocalRepository.getIsFirstTime();
      if (isFirstTime) {
        emit(FirstTimeUse());
        await _authLocalRepository.setIsFirstTime();
        return;
      }

      final isGuest = await _authLocalRepository.getIsGuest();
      final isAuthenticated = await _authRemoteRepository.isAuthenticated();
      if (isGuest || isAuthenticated) {
        emit(Authenticated());
        return;
      }

      emit(Unauthenticated());
    });
  }
}
