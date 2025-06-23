import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supermarket/core/utils/extensions.dart';

class BoardingDotIndicator extends StatelessWidget {
  const BoardingDotIndicator({
    super.key,
    required this.controller,
    required this.pageCount,
    this.onDotClicked,
  });

  final int pageCount;
  final PageController controller;
  final void Function(int)? onDotClicked;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: pageCount,
      onDotClicked: onDotClicked,

      effect: CustomizableEffect(
        spacing: 8.w,
        dotDecoration: DotDecoration(
          width: 32.w,
          height: 8.h,
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(8.r),
        ),
        activeDotDecoration: DotDecoration(
          width: 52.w,
          height: 8.h,
          color: context.theme.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
