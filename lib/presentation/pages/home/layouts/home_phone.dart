import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/pages/cashier/cachier_page.dart';
import 'package:supermarket/presentation/pages/inventory/inventory_page.dart';

class HomePhone extends StatefulWidget {
  const HomePhone({super.key});

  @override
  State<HomePhone> createState() => _HomePhoneState();
}

class _HomePhoneState extends State<HomePhone> {
  final List<BottomNavigationBarItem> _navbarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: AppStrings.home),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory_2_rounded),
      label: AppStrings.inventory,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: AppStrings.stats,
    ),
  ];
  static const List<Widget> _pages = [
    CashierPage(),
    InventoryPage(),
    CashierPage(),
  ];
  int selectedIndex = 0;

  FloatingActionButton get _getCashierCheckoutButton {
    return FloatingActionButton.extended(
      label: Text(AppStrings.checkout),
      onPressed: () {
        log("UnImplemented Checkout");
      },
    );
  }

  FloatingActionButton get _getInventoryAddItemButton {
    return FloatingActionButton.extended(
      label: Text(AppStrings.addItem),
      onPressed: () => context.pushNamed(AppRoutes.addItem),
    );
  }

  FloatingActionButton? _buildFABs(int index) {
    switch (index) {
      case 0:
        return _getCashierCheckoutButton;
      case 1:
        return _getInventoryAddItemButton;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFABs(selectedIndex),
      body: LazyLoadIndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: context.colorScheme.primary,
        backgroundColor: context.colorScheme.surface,
        unselectedItemColor: context.colorScheme.onSecondary,
        currentIndex: selectedIndex,
        items: _navbarItems,
        onTap:
            (value) => setState(() {
              selectedIndex = value;
            }),
      ),
    );
  }
}
