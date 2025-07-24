import 'package:flutter/material.dart';
import 'package:supermarket/core/constants/app_strings.dart';

class SelectImageSourceBottomSheet extends StatelessWidget {
  const SelectImageSourceBottomSheet({
    super.key,
    required this.galleryAction,
    required this.cameraAction,
    required this.isMobilePlatform,
  });
  final VoidCallback galleryAction;
  final VoidCallback cameraAction;
  final bool isMobilePlatform;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: Text(AppStrings.gallery),
          onTap: galleryAction,
        ),
        isMobilePlatform
            ? ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppStrings.camera),
              onTap: cameraAction,
            )
            : const SizedBox.shrink(),
      ],
    );
  }
}
