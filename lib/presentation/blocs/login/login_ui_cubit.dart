import 'package:flutter_bloc/flutter_bloc.dart';

class LoginUiCubit extends Cubit<bool> {
  LoginUiCubit() : super(false);

  void togglePasswordVisibility() {
    emit(!state);
  }
}
