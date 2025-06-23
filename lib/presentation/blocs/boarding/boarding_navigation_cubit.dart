import 'package:flutter_bloc/flutter_bloc.dart';

class BoardingNavigationCubit extends Cubit<int> {
  BoardingNavigationCubit() : super(0);

  void nextPage(int pageCount) {
    emit(state + 1);
  }

  void goToPage(int pageIndex) {
    emit(pageIndex);
  }
}
