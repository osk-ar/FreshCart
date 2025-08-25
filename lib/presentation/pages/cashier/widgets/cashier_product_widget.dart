import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class CashierProductWidget extends StatelessWidget {
  const CashierProductWidget({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final ProductEntity product;

  final VoidCallback onAddToCart;

  //todo translate
  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),

      child: SizedBox(
        height: 124.h,
        child: Padding(
          padding: EdgeInsets.only(
            left: 4.r,
            top: 4.r,
            bottom: 4.r,
            right: 8.r,
          ),
          child: Row(
            spacing: 4.w,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              product.imagePath != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),

                    child: Image.file(
                      File(product.imagePath!),
                      cacheWidth: (116 * pixelRatio).round(),
                      cacheHeight: (116 * pixelRatio).round(),
                      fit: BoxFit.fill,
                      width: 116.r,
                    ),
                  )
                  : Container(
                    width: 116.r,
                    height: 116.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.all(
                      product.imagePath != null ? 0 : 12.r,
                    ),
                    child: Icon(
                      Icons.airplay_rounded,
                      size: 64.r,
                      color: context.colorScheme.surface,
                    ),
                  ),

              Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox.shrink(),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: context.colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: "${AppStrings.name}: ",
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        TextSpan(text: product.name),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: context.colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: "${AppStrings.price}: ",
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        TextSpan(text: product.price!.toString()),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: context.colorScheme.onSurface),
                      children: [
                        TextSpan(
                          text: "${AppStrings.quantity}: ",
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        TextSpan(text: product.quantity!.toString()),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompactElevatedButton(
                    title: "Add to cart",
                    onPressed: onAddToCart,
                    padding: EdgeInsets.zero,
                    titleStyle: TextStyle(
                      color: context.colorScheme.onPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompactElevatedButton extends StatelessWidget {
  const CompactElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.titleStyle,
  });
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
          side: BorderSide(width: 1.r, color: context.colorScheme.primary),
        ),
        fixedSize: Size(100.w, 36.h),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(title, style: titleStyle),
    );
  }
}
