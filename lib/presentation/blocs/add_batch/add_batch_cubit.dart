import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/presentation/blocs/add_batch/state/add_batch_state.dart';

class AddBatchCubit extends Cubit<AddBatchState> {
  AddBatchCubit() : super(AddBatchInitial());

  void selectProductionDate(DateTime date) {
    emit(AddBatchProductoinDateSelected(date));
  }

  void selectExpiryDate(DateTime date) {
    emit(AddBatchExpiryDateSelected(date));
  }
}
