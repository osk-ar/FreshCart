import 'package:flutter/material.dart';
import 'package:supermarket/presentation/pages/inventory/layouts/inventory_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptiveLayout(
      phoneLayout: InventoryPhone(),
      tabletLayout: InventoryPhone(),
      desktopLayout: InventoryPhone(),
    );
  }
}
