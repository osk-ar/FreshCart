import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supermarket/core/utils/extensions.dart';

class BoardingContentPage extends StatelessWidget {
  const BoardingContentPage({
    super.key,
    required this.assetName,
    required this.title,
    required this.description,
  });
  final String assetName;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        spacing: 16.h,
        children: [
          SizedBox(height: 24.h),
          SvgPicture.asset(
            assetName,
            height: MediaQuery.of(context).size.width * 0.75,
          ),
          Text(
            title,
            style: context.theme.textTheme.displaySmall?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(description, style: context.theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
