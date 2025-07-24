import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/add_batch/add_batch_cubit.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/pages/add_batch/layouts/add_batch_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class AddBatchPage extends StatelessWidget {
  const AddBatchPage({super.key, required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<InventoryCubit>()),
        BlocProvider(create: (context) => serviceLocator<AddBatchCubit>()),
      ],

      child: AdaptiveLayout(
        phoneLayout: AddBatchPhone(product: product),
        tabletLayout: AddBatchPhone(product: product),
        desktopLayout: AddBatchPhone(product: product),
      ),
    );
  }
}
