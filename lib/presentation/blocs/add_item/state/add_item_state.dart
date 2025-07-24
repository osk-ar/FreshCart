abstract class AddItemState {}

class AddItemInitial extends AddItemState {}

class AddItemThumbnailChanged extends AddItemState {
  final String? imagePath;
  AddItemThumbnailChanged(this.imagePath);
}

class AddItemError extends AddItemState {
  final String message;
  AddItemError(this.message);
}
