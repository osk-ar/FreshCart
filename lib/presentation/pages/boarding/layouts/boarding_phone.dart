import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/constants/app_routes.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/boarding/boarding_navigation_cubit.dart';
import 'package:supermarket/presentation/pages/boarding/widgets/boarding_content_page.dart';
import 'package:supermarket/presentation/pages/boarding/widgets/boarding_dot_indicator.dart';
import 'package:supermarket/presentation/pages/boarding/widgets/boarding_navigation_button.dart';

class BoardingPhone extends StatefulWidget {
  const BoardingPhone({super.key});

  @override
  State<BoardingPhone> createState() => _BoardingPhoneState();
}

class _BoardingPhoneState extends State<BoardingPhone> {
  late final PageController controller;
  final int pageCount = 3;
  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => context.pushReplacementNamed(AppRoutes.register),
            child: Text(
              AppStrings.skip,
              style: context.theme.textTheme.titleMedium?.copyWith(
                color: context.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BoardingNavigationCubit, int>(
        listener: (context, pageIndex) {
          if (pageIndex > pageCount - 1) {
            context.pushReplacementNamed(AppRoutes.register);
          } else {
            controller.animateToPage(
              pageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        builder: (context, pageIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 24.h,
            children: [
              Flexible(
                child: PageView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    BoardingContentPage(
                      assetName: AppPaths.sync,
                      title: AppStrings.onboardingTitle1,
                      description: AppStrings.onboardingDesc1,
                    ),
                    BoardingContentPage(
                      assetName: AppPaths.monitorAnalytics,
                      title: AppStrings.onboardingTitle2,
                      description: AppStrings.onboardingDesc2,
                    ),
                    BoardingContentPage(
                      assetName: AppPaths.stepUp,
                      title: AppStrings.onboardingTitle3,
                      description: AppStrings.onboardingDesc3,
                    ),
                  ],
                ),
              ),

              //* navigation row
              Padding(
                padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BoardingDotIndicator(
                      controller: controller,
                      pageCount: pageCount,
                      onDotClicked:
                          (index) => context
                              .read<BoardingNavigationCubit>()
                              .goToPage(index),
                    ),
                    BoardingNavigationButton(
                      pageIndex: pageIndex,
                      pageCount: pageCount,
                      onPressed:
                          () => context
                              .read<BoardingNavigationCubit>()
                              .nextPage(pageCount),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
