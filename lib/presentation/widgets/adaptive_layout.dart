import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  /// The layout to display on small screens (phones).
  final Widget phoneLayout;

  /// The layout to display on medium screens (tablets).
  final Widget tabletLayout;

  /// The layout to display on large screens (desktops).
  final Widget desktopLayout;

  /// Breakpoint for switching from phone to tablet layout.
  /// Any screen width greater than this value will be considered a tablet.
  static const int kTabletBreakpoint = 600;

  /// Breakpoint for switching from tablet to desktop layout.
  /// Any screen width greater than this value will be considered a desktop.
  static const int kDesktopBreakpoint = 1200;

  const AdaptiveLayout({
    super.key,
    required this.phoneLayout,
    required this.tabletLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder provides the constraints of the parent widget.
    // We use these constraints, specifically the maxWidth, to decide which
    // layout to build.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // If the screen width is greater than the desktop breakpoint,
        // show the desktop layout.
        if (constraints.maxWidth > kDesktopBreakpoint) {
          return desktopLayout;
        }
        // If the screen width is greater than the tablet breakpoint,
        // show the tablet layout.
        else if (constraints.maxWidth > kTabletBreakpoint) {
          return tabletLayout;
        }
        // Otherwise, default to the phone layout.
        else {
          return phoneLayout;
        }
      },
    );
  }
}
