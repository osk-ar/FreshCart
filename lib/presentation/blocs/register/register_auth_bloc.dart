import 'package:flutter_bloc/flutter_bloc.dart';
part 'package:supermarket/presentation/blocs/register/events/register_auth_event.dart';
part 'package:supermarket/presentation/blocs/register/states/register_auth_state.dart';

class RegisterAuthBloc extends Bloc<RegisterAuthEvent, AuthState> {
  RegisterAuthBloc() : super(AuthInitial()) {
    on<RegisterWithEmailAndPassword>((event, emit) {});
    on<RegisterWithGoogle>((event, emit) {});
    on<RegisterWithGuest>((event, emit) {});
  }
}
