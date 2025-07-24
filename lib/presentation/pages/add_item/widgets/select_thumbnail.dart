import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/utils/extensions.dart';

class SelectThumbnailWidget extends StatelessWidget {
  const SelectThumbnailWidget({
    super.key,
    this.imagePath,
    required this.onSelectImage,
    required this.onRemoveImage,
    required this.cropController,
  });

  final String? imagePath;
  final VoidCallback onSelectImage;
  final VoidCallback onRemoveImage;
  final CropController cropController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (imagePath == null) {
          onSelectImage();
          return;
        } else {
          onRemoveImage();
          return;
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).width - 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: context.colorScheme.surface,
        ),
        child:
            imagePath != null
                ? CropImage(
                  controller: cropController,
                  image: Image.file(File(imagePath!)),
                  alwaysMove: true,
                )
                : Column(
                  spacing: 8.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.airplay_rounded,
                      size: 64.r,
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                    Text(
                      AppStrings.clickToAddThumbnail,
                      style: context.theme.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
