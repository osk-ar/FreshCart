import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUiCubit extends Cubit<bool> {
  RegisterUiCubit() : super(true);

  void togglePasswordVisibility() {
    emit(!state);
  }
}
