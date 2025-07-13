import 'dart:io';

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

  Future<File?> resizeImage(
    File originalImage,
    int newWidth,
    int newHeight,
  ) async {
    final image = img.decodeImage(await originalImage.readAsBytes());

    if (image != null) {
      final thumbnail = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
      );

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      final resizedImageFile = File(
        '$path/thumbnail_${DateTime.now().millisecondsSinceEpoch}.png',
      )..writeAsBytesSync(img.encodePng(thumbnail));

      return resizedImageFile;
    } else {
      throw ResizingMediaFailure();
    }
  }

  Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;

    final file = File(imagePath);
    await file.delete();
  }
}
