import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supermarket/core/utils/extensions.dart';

class InventoryProductShimmer extends StatelessWidget {
  const InventoryProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerBaseColor = context.colorScheme.surface;
    final shimmerHighlightColor = context.colorScheme.primary.withAlpha(75);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: SizedBox(
        height: 124.h,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 116.r,
                  height: 116.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  spacing: 16.h,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox.shrink(),
                    _buildPlaceholderLine(context, width: 160.w, height: 16.h),
                    _buildPlaceholderLine(context, width: 100.w, height: 16.h),
                  ],
                ),
                SizedBox(width: 8.w),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildPlaceholderLine(
                    context,
                    width: 60.w,
                    height: 24.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderLine(
    BuildContext context, {
    required double width,
    double height = 16.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
