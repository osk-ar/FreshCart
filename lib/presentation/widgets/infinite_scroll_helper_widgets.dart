import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/constants/app_strings.dart';

class FirstPageProgressIndicator extends StatelessWidget {
  const FirstPageProgressIndicator({super.key, required this.shimmer});
  final Widget shimmer;

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 8.h, children: List.generate(5, (index) => shimmer));
  }
}

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key, required this.isSearch});
  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 64.h,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppPaths.empty),
        Text(
          isSearch
              ? AppStrings.noProductsFoundForQuery
              : AppStrings.noProductsFoundHint,
        ),
        const SizedBox.shrink(),
      ],
    );
  }
}

class NoMoreItemsIndicator extends StatelessWidget {
  const NoMoreItemsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(child: Text(AppStrings.noMoreResults)),
    );
  }
}
