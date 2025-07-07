import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onPressed});
  final String label;
  final bool isLoading = false;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(minimumSize: Size(358.w, 48.h)),
      child:
          isLoading
              ? CircularProgressIndicator(color: context.colorScheme.surface)
              : Text(label),
    );
  }
}
