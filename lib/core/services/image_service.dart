import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket/core/error/failures.dart';

class ImageService {
  final ImagePicker _picker;
  ImageService(this._picker);

  Future<XFile> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        return image;
      }
      throw PickingMediaFailure();
    } catch (e) {
      throw UnknownMediaFailure(message: e.toString());
    }
  }

  Future<XFile> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        return image;
      }
      throw PickingMediaFailure();
    } catch (e) {
      throw UnknownMediaFailure(message: e.toString());
    }
  }

  static Future<File> resizeAndSaveImage({
    required int width,
    required int height,
    required Uint8List originalImageBytes,
    required int newWidth,
    required int newHeight,
  }) async {
    final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: originalImageBytes.buffer,
      format: img.Format.uint8,
      order: img.ChannelOrder.rgba,
    );

    final thumbnail = img.copyResize(
      image,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.average,
    );

    final resizedBytes = img.encodeJpg(thumbnail, quality: 90);

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final filePath =
        '$path/product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final resizedImageFile = File(filePath);

    await resizedImageFile.writeAsBytes(resizedBytes);

    return resizedImageFile;
  }

  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      log("Error deleting file: $imagePath, error: $e");
    }
  }
}
