import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/utils/extensions.dart';

class AnimatedProgressIndicator extends StatefulWidget {
  const AnimatedProgressIndicator({
    super.key,
    required this.pageCount,
    required this.pageIndex,
    required this.radius,
  });
  final int pageCount;
  final int pageIndex;
  final double radius;

  @override
  State<AnimatedProgressIndicator> createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final double initialProgress = (widget.pageIndex + 1) / widget.pageCount;
    _animation = Tween<double>(
      begin: 0.0,
      end: initialProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pageIndex != oldWidget.pageIndex) {
      final newProgress = (widget.pageIndex + 1) / widget.pageCount;
      _updateAnimation(newProgress);
    }
  }

  void _updateAnimation(double newProgress) {
    _animation = Tween<double>(
      begin: _animation.value,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller
      ..value = 0
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder:
            (context, _) => CircularProgressIndicator(
              value: _animation.value,
              color: context.theme.primaryColor,
              backgroundColor: context.colorScheme.surface,
              constraints: BoxConstraints(
                minHeight: widget.radius.r * 2,
                minWidth: widget.radius.r * 2,
              ),
              strokeWidth: 2.w,
            ),
      ),
    );
  }
}
