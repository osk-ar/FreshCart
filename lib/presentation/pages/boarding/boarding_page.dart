import 'package:flutter/material.dart';
import 'package:supermarket/presentation/pages/boarding/layouts/boarding_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptiveLayout(
      phoneLayout: BoardingPhone(),
      desktopLayout: BoardingPhone(),
      tabletLayout: BoardingPhone(),
    );
  }
}
