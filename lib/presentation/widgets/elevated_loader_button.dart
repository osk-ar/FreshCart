import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

class ElevatedLoaderButton extends StatefulWidget {
  const ElevatedLoaderButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final Future<void> Function() onPressed;
  final String text;

  @override
  State<ElevatedLoaderButton> createState() => _ElevatedLoaderButtonState();
}

class _ElevatedLoaderButtonState extends State<ElevatedLoaderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(48.h)),
      onPressed: () async {
        if (isLoading) return;

        setState(() {
          isLoading = true;
        });

        await widget.onPressed();

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });
      },
      child:
          isLoading
              ? CircularProgressIndicator.adaptive(
                backgroundColor: context.colorScheme.onPrimary,
                padding: EdgeInsets.all(8.r),
              )
              : Text(widget.text),
    );
  }
}
