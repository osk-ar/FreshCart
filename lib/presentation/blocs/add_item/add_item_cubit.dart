import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermarket/core/error/failures.dart';
import 'package:supermarket/core/services/image_service.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/add_item/state/add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  final ImageService _imageService;
  AddItemCubit(this._imageService) : super(AddItemInitial());

  ProductEntity newProduct = ProductEntity();

  Future<void> pickImageFromGallery() async {
    try {
      final XFile image = await _imageService.pickImageFromGallery();
      newProduct.imagePath = image.path;
      emit(AddItemThumbnailChanged(image.path));
    } catch (e) {
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
    try {
      newProduct.id = id;
      newProduct.name = name;
      newProduct.price = price;
      newProduct.quantity = 0;

      newProduct.imagePath = await _processCroppedImage(
        cropController,
        pixelRatio,
      );

      return newProduct;
    } catch (e) {
      log(e.toString());
      emit(AddItemError(e.toString()));
      return newProduct;
    }
  }

  Future<String?> _processCroppedImage(
    CropController cropController,
    double pixelRatio,
  ) async {
    try {
      ui.Image bitmap = await cropController.croppedBitmap();

      final int width = bitmap.width;
      final int height = bitmap.height;
      final ByteData? data = await bitmap.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (data == null) {
        throw ResizingMediaFailure();
      }

      final Uint8List bytes = data.buffer.asUint8List();

      final RootIsolateToken token = RootIsolateToken.instance!;

      final String? imagePath = await Isolate.run(
        () async => await _resizeImageInIsolate({
          'width': width,
          'height': height,
          'bytes': bytes,
          'pixelRatio': pixelRatio,
          'token': token,
        }),
      );

      return imagePath;
    } catch (e) {
      log("Error in _processCroppedImage: ${e.toString()}");
      return null;
    }
  }

  static Future<String?> _resizeImageInIsolate(
    Map<String, dynamic> params,
  ) async {
    final int width = params['width'];
    final int height = params['height'];
    final Uint8List originalImageBytes = params['bytes'];
    final double pixelRatio = params['pixelRatio'];
    final int thumbnailSize = (116 * pixelRatio).round();
    final RootIsolateToken token = params['token'];

    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    final File resizedImage = await ImageService.resizeAndSaveImage(
      width: width,
      height: height,
      originalImageBytes: originalImageBytes,
      newWidth: thumbnailSize,
      newHeight: thumbnailSize,
    );

    return resizedImage.path;
  }
}
