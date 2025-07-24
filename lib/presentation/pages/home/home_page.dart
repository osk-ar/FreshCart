import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/cashier/cashier_bloc.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/pages/home/layouts/home_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CashierBloc>(create: (context) => serviceLocator()),
        BlocProvider<InventoryCubit>(create: (context) => serviceLocator()),
      ],
      child: const AdaptiveLayout(
        phoneLayout: HomePhone(),
        tabletLayout: HomePhone(),
        desktopLayout: HomePhone(),
      ),
    );
  }
}
