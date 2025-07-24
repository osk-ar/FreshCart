abstract class AddBatchState {}

class AddBatchInitial extends AddBatchState {}

class AddBatchProductoinDateSelected extends AddBatchState {
  final DateTime date;

  AddBatchProductoinDateSelected(this.date);
}

class AddBatchExpiryDateSelected extends AddBatchState {
  final DateTime date;

  AddBatchExpiryDateSelected(this.date);
}
