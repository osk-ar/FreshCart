import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

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
        fixedSize: Size.fromHeight(36.h),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(title, style: titleStyle),
    );
  }
}
