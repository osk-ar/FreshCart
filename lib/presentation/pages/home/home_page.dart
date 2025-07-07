import 'package:flutter/material.dart';
import 'package:supermarket/presentation/pages/home/layouts/home_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      phoneLayout: HomePhone(),
      tabletLayout: HomePhone(),
      desktopLayout: HomePhone(),
    );
  }
}
