import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocalizationButton extends StatelessWidget {
  const LocalizationButton({
    super.key,
    this.onPressed,
    required this.languageCode,
  });
  final VoidCallback? onPressed;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 5,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(languageCode.toUpperCase()),
    );
  }
}
