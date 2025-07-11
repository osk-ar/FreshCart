import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

class SliverAppbarWithSearchButton extends StatelessWidget {
  const SliverAppbarWithSearchButton({
    super.key,
    required this.onSearchPressed,
    required this.title,
  });
  final VoidCallback onSearchPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      //todo translate
      title: Text(title, style: TextStyle(color: context.colorScheme.primary)),
      actions: [
        IconButton(
          onPressed: onSearchPressed,
          icon: Icon(Icons.search, color: context.colorScheme.primary),
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.surface,
          ),
        ),
        SizedBox(width: 12.w),
      ],
    );
  }
}
