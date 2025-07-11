import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/pages/cashier/cachier_page.dart';
import 'package:supermarket/presentation/pages/inventory/inventory_page.dart';

class HomePhone extends StatefulWidget {
  const HomePhone({super.key});

  @override
  State<HomePhone> createState() => _HomePhoneState();
}

class _HomePhoneState extends State<HomePhone> {
  //todo translate
  static const List<BottomNavigationBarItem> _navbarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.inventory_2_rounded),
      label: "Inventory",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: "Stats",
    ),
  ];
  static const List<Widget> _pages = [
    CashierPage(),
    InventoryPage(),
    CashierPage(),
  ];
  int selectedIndex = 0;

  FloatingActionButton get _getCashierCheckoutButton {
    //todo translate
    return FloatingActionButton.extended(
      label: Text("Checkout"),
      onPressed: () {
        log("UnImplemented Checkout");
      },
    );
  }

  FloatingActionButton get _getInventoryAddItemButton {
    //todo translate
    return FloatingActionButton.extended(
      label: Text("Add Item"),
      onPressed: () {
        log("UnImplemented Add Item");
      },
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
