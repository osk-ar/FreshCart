import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key, required this.label, this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(358.w, 40.h),
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.onSurface,
      ),
      child: Text(label),
    );
  }
}
