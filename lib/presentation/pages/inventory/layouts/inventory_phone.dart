import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/inventory/events/inventory_event.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:supermarket/presentation/blocs/inventory/states/inventory_state.dart';
import 'package:supermarket/presentation/widgets/search_sliver_appbar.dart';
import 'package:supermarket/presentation/widgets/sliver_appbar_with_search_button.dart';

class InventoryPhone extends StatefulWidget {
  const InventoryPhone({super.key});

  @override
  State<InventoryPhone> createState() => _InventoryPhoneState();
}

class _InventoryPhoneState extends State<InventoryPhone> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(InventoryFetchItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        BlocBuilder<InventoryBloc, InventoryState>(
          buildWhen: (previous, current) {
            return current is InventorySearching || current is InventoryLoaded;
          },
          builder: (context, state) {
            log(state.runtimeType.toString());
            switch (state) {
              case InventorySearching():
                return SearchSliverAppbar(
                  onSearchChanged: (query) {
                    context.read<InventoryBloc>().add(
                      InventoryChangeSearchEvent(query),
                    );
                  },
                  onClear: () {
                    final String lastQuery =
                        context.read<InventoryBloc>().searchQuery;

                    if (lastQuery.isEmpty) {
                      context.pop();
                      context.read<InventoryBloc>().add(
                        InventoryEndSearchEvent(),
                      );
                      return;
                    }

                    context.read<InventoryBloc>().add(
                      InventoryChangeSearchEvent(""),
                    );
                  },
                );
              default:
                return SliverAppbarWithSearchButton(
                  title: "Inventory",
                  onSearchPressed: () {
                    context.read<InventoryBloc>().add(
                      InventoryStartSearchEvent(),
                    );
                    ModalRoute.of(context)!.addLocalHistoryEntry(
                      LocalHistoryEntry(
                        onRemove: () {
                          context.read<InventoryBloc>().add(
                            InventoryEndSearchEvent(),
                          );
                        },
                      ),
                    );
                  },
                );
            }
          },
        ),

        SliverToBoxAdapter(child: SizedBox(height: 8.h)),

        BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            switch (state) {
              case InventorySearching():
                return SliverList.builder(
                  itemCount: state.searchedProducts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.searchedProducts.length) {
                      return context
                                  .read<InventoryBloc>()
                                  .isSearchLastItemReached ||
                              state.searchedProducts.isEmpty
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.searchedProducts.isEmpty
                                    ? "No products found for this query"
                                    : "No More Results",
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                    }
                    return InventoryProduct();
                  },
                );
              case InventoryLoaded():
                return SliverList.builder(
                  itemCount: state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.products.length) {
                      return context.read<InventoryBloc>().isFeedLastItemReached
                          ? SizedBox(
                            height: 64.h,
                            child: Center(
                              child: Text(
                                state.products.isEmpty
                                    ? "No Products Found, try adding an item!"
                                    : "No More Results",
                              ),
                            ),
                          )
                          : SizedBox(
                            height: 64.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                    }
                    return InventoryProduct();
                  },
                );

              default:
                return SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const InventoryProductShimmer();
                  },
                );
            }
          },
        ),
      ],
    );
  }
}

class InventoryProductShimmer extends StatelessWidget {
  const InventoryProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerBaseColor = context.colorScheme.surface;
    final shimmerHighlightColor = context.colorScheme.primary.withAlpha(75);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: SizedBox(
        height: 124.h,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Image Placeholder
                Container(
                  width: 116.r,
                  height: 116.r,
                  decoration: BoxDecoration(
                    color: Colors.white, // Color is required by shimmer
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 8.w),
                // 2. Text Details Placeholder
                Column(
                  spacing: 16.h,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox.shrink(),
                    _buildPlaceholderLine(context, width: 160.w),
                    _buildPlaceholderLine(context, width: 100.w),
                  ],
                ),
                SizedBox(width: 8.w),

                // 3. Buttons Placeholder
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildPlaceholderLine(
                    context,
                    width: 60.w,
                    height: 24.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget to build a single shimmering line placeholder.
  Widget _buildPlaceholderLine(
    BuildContext context, {
    required double width,
    double height = 16.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            Colors.white, // This color will be overridden by the shimmer effect
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class InventoryProduct extends StatelessWidget {
  const InventoryProduct({super.key, this.imagePath});
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),

      child: SizedBox(
        height: 124.h,
        child: Padding(
          padding: EdgeInsets.only(
            left: 4.r,
            top: 4.r,
            bottom: 4.r,
            right: 8.r,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imagePath != null
                  ? Image.file(
                    File(imagePath!),
                    cacheWidth: (116 * pixelRatio).round(),
                    cacheHeight: (116 * pixelRatio).round(),
                    fit: BoxFit.cover,
                  )
                  : Container(
                    width: 116.r,
                    height: 116.r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.all(12.r),
                    child: Icon(
                      Icons.airplay_rounded,
                      size: 64.r,
                      color: context.colorScheme.surface,
                    ),
                  ),
              SizedBox(width: 4.w),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox.shrink(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: context.colorScheme.onSurface),
                        children: [
                          TextSpan(
                            text: "Name: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
                          ),
                          TextSpan(text: "Al-Dohaa Rice"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: context.colorScheme.onSurface),
                        children: [
                          TextSpan(
                            text: "Price: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
                          ),
                          TextSpan(text: "39.99"),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: context.colorScheme.onSurface),
                        children: [
                          TextSpan(
                            text: "QTY: ",
                            style: TextStyle(
                              color: context.colorScheme.primary,
                            ),
                          ),
                          TextSpan(text: "14"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CompactElevatedButton(
                      title: "Edit",
                      onPressed: () {},
                      backgroundColor: context.theme.scaffoldBackgroundColor,
                      padding: EdgeInsets.zero,
                      titleStyle: TextStyle(
                        color: context.colorScheme.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete_rounded,
                            color: context.colorScheme.error,
                          ),
                        ),
                        CompactElevatedButton(
                          title: "ReStock",
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          titleStyle: TextStyle(
                            color: context.colorScheme.onPrimary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(title, style: titleStyle),
    );
  }
}
