import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/utils/extensions.dart';

class SearchSliverAppbar extends StatefulWidget {
  const SearchSliverAppbar({
    super.key,
    required this.onSearchChanged,
    this.lastQuery,
  });
  final void Function(String) onSearchChanged;
  final String? lastQuery;

  @override
  State<SearchSliverAppbar> createState() => _SearchSliverAppbarState();
}

class _SearchSliverAppbarState extends State<SearchSliverAppbar> {
  static const int _debounceMilliSeconds = 800;
  Timer? _debounceTimer;

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..text = widget.lastQuery ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: context.colorScheme.surface,
      title: TextField(
        controller: _controller,
        decoration: InputDecoration(
          filled: false,
          hintText: AppStrings.searchForProducts,
          constraints: BoxConstraints(maxWidth: 324.w),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0.r),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (query) {
          _debounceTimer?.cancel();
          _debounceTimer = Timer(
            const Duration(milliseconds: _debounceMilliSeconds),
            () => widget.onSearchChanged(query),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            final String lastQuery = _controller.text;

            if (lastQuery.isEmpty) {
              context.pop();
              return;
            }

            _controller.clear();
            widget.onSearchChanged("");
          },
          icon: Icon(Icons.clear_rounded, color: context.colorScheme.primary),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}


/*

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      collapsedHeight: 86.h,
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for groceries",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0.r),
                  borderSide: BorderSide.none,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                constraints: BoxConstraints(maxWidth: 324.w),
              ),
              onChanged: onSearchChanged,
            ),
            IconButton(
              onPressed: onClearPressed,
              icon: Icon(Icons.clear_rounded),
              style: IconButton.styleFrom(
                backgroundColor: context.colorScheme.secondary,
                foregroundColor: context.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */