import 'package:flutter/material.dart';
import 'package:supermarket/core/utils/extensions.dart';

class AuthNavigationText extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final VoidCallback onPressed;

  const AuthNavigationText({
    super.key,
    required this.leadingText,
    required this.trailingText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(leadingText, style: context.theme.textTheme.bodyMedium),
        TextButton(
          onPressed: onPressed,
          child: Text(
            trailingText,
            style: context.theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
