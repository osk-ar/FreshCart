import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/pages/inventory/widgets/compact_elevated_button.dart';

//todo translate
class InventoryProduct extends StatelessWidget {
  const InventoryProduct({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onRestock,
  });
  final ProductEntity product;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestock;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    log(product.imagePath.toString());
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              SizedBox(width: 4.w),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox.shrink(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: context.colorScheme.onSurface),
                        children: [
                          TextSpan(
                            text: "Name: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
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
                            text: "Price: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
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
                            text: "QTY: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
                          ),
                          TextSpan(text: product.quantity!.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CompactElevatedButton(
                      title: "Edit",
                      onPressed: onEdit,
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      padding: EdgeInsets.zero,
                      titleStyle: TextStyle(
                        color: context.colorScheme.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: onDelete,
                          icon: Icon(
                            Icons.delete_rounded,
                            color: context.colorScheme.error,
                          ),
                        ),
                        CompactElevatedButton(
                          title: "ReStock",
                          onPressed: onRestock,
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
            ],
          ),
        ),
      ),
    );
  }
}
