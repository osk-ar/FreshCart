import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/add_item/add_item_cubit.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/pages/add_item/layouts/add_item_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class AddItemPage extends StatelessWidget {
  const AddItemPage({super.key, this.productToUpdate});
  final ProductEntity? productToUpdate;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<InventoryCubit>()),
        BlocProvider(create: (context) => serviceLocator<AddItemCubit>()),
      ],
      child: AdaptiveLayout(
        phoneLayout: AddItemPhone(productToUpdate: productToUpdate),
        tabletLayout: AddItemPhone(productToUpdate: productToUpdate),
        desktopLayout: AddItemPhone(productToUpdate: productToUpdate),
      ),
    );
  }
}
