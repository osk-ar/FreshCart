import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/cashier/cashier_bloc.dart';
import 'package:supermarket/presentation/pages/cashier/layouts/cashier_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class CashierPage extends StatelessWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CashierBloc>(),
      child: AdaptiveLayout(
        phoneLayout: CashierPhone(),
        tabletLayout: CashierPhone(),
        desktopLayout: CashierPhone(),
      ),
    );
  }
}
