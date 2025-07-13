import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket/core/services/image_service.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final ImageService _imageService;
  AddItemCubit(this._imageService) : super(AddItemInitial());

  ProductEntity newProduct = ProductEntity();

  Future<void> pickImageFromGallery() async {
    log("pick from gallery");
    try {
      final XFile image = await _imageService.pickImageFromGallery();
      newProduct.imagePath = image.path;
      emit(AddItemThumbnailChanged(image.path));
    } catch (e) {
      log(e.toString());
      emit(AddItemError(e.toString()));
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile image = await _imageService.pickImageFromCamera();
      newProduct.imagePath = image.path;
      emit(AddItemThumbnailChanged(image.path));
    } catch (e) {
      emit(AddItemError(e.toString()));
    }
  }

  Future<void> removeImage() async {
    emit(AddItemThumbnailChanged(null));
  }

  Future<ProductEntity> onSubmit(
    String name,
    double price,
    CropController cropController,
    double pixelRatio, [
    int? id,
  ]) async {
    newProduct.id = id;
    newProduct.name = name;
    newProduct.price = price;
    newProduct.quantity = 0;

    newProduct.imagePath = await _getCroppedImagePath(
      cropController,
      pixelRatio,
    );

    return newProduct;
  }

  Future<String?> _getCroppedImagePath(
    CropController cropController,
    double pixelRatio,
  ) async {
    try {
      ui.Image bitmap = await cropController.croppedBitmap();

      final ByteData? data = await bitmap.toByteData(
        format: ui.ImageByteFormat.png,
      );

      final Uint8List bytes = data!.buffer.asUint8List();

      final File croppedImage = await _saveImageBytesToFile(bytes);

      final File? resizedImage = await _resizeImage(
        croppedImage,
        (116 * pixelRatio).round(),
        (116 * pixelRatio).round(),
      );

      _deleteTempImage();

      return resizedImage?.path;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<File?> _resizeImage(
    File originalImage,
    int newWidth,
    int newHeight,
  ) async {
    try {
      final File? resizedImage = await _imageService.resizeImage(
        originalImage,
        newWidth,
        newHeight,
      );
      return resizedImage!;
    } catch (e) {
      emit(AddItemError(e.toString()));
    }
    return null;
  }

  Future<File> _saveImageBytesToFile(Uint8List bytes) async {
    final Directory tempDir = await getTemporaryDirectory();

    final String filePath = '${tempDir.path}/cropped_image.png';

    final File file = File(filePath);

    await file.writeAsBytes(bytes);

    return file;
  }

  void _deleteTempImage() async {
    final Directory tempDir = await getTemporaryDirectory();

    final String filePath = '${tempDir.path}/cropped_image.png';

    final File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

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
