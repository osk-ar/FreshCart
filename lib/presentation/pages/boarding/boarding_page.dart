import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/boarding/boarding_navigation_cubit.dart';
import 'package:supermarket/presentation/pages/boarding/layouts/boarding_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class BoardingPage extends StatelessWidget {
  const BoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BoardingNavigationCubit>(),
      child: const AdaptiveLayout(
        phoneLayout: BoardingPhone(),
        desktopLayout: BoardingPhone(),
        tabletLayout: BoardingPhone(),
      ),
    );
  }
}
