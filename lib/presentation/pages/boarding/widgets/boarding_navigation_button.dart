import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/widgets/animated_progress_indicator.dart';

class BoardingNavigationButton extends StatelessWidget {
  const BoardingNavigationButton({
    super.key,
    required this.onPressed,
    required this.pageIndex,
    required this.pageCount,
  });
  final int pageIndex;
  final int pageCount;
  final VoidCallback onPressed;

  final double progressIndicatorRadius = 35.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedProgressIndicator(
          pageCount: pageCount,
          pageIndex: pageIndex,
          radius: progressIndicatorRadius,
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.arrow_forward_ios_rounded),
          constraints: BoxConstraints(
            minHeight: (progressIndicatorRadius.r * 2) - 8.r,
            minWidth: (progressIndicatorRadius.r * 2) - 8.r,
          ),
          style: IconButton.styleFrom(
            backgroundColor: context.theme.primaryColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: EdgeInsets.all(12.w),
          ),
        ),
      ],
    );
  }
}
