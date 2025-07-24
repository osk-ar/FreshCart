import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/services/validation_service.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_batch_entity.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/add_batch/add_batch_cubit.dart';
import 'package:supermarket/presentation/blocs/add_batch/state/add_batch_state.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/widgets/date_picker_widget.dart';

class AddBatchPhone extends StatefulWidget {
  const AddBatchPhone({super.key, required this.product});
  final ProductEntity product;

  @override
  State<AddBatchPhone> createState() => _AddBatchPhoneState();
}

class _AddBatchPhoneState extends State<AddBatchPhone> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();

  final FocusNode _quantityFocusNode = FocusNode();
  final FocusNode _purchasePriceFocusNode = FocusNode();

  DateTime? _productionDate;
  DateTime? _expiryDate;

  static const Duration _dateMargin = Duration(days: 365 * 50);

  @override
  void dispose() {
    _quantityController.dispose();
    _purchasePriceController.dispose();

    _quantityFocusNode.dispose();
    _purchasePriceFocusNode.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final String? validateProductionExist = ValidationService.validateDate(
      _productionDate,
    );
    final String? validateExpiryExist = ValidationService.validateDate(
      _productionDate,
    );
    final String? validateExpiryValue = ValidationService.validateExpiryDate(
      productionDate: _productionDate!,
      expiryDate: _expiryDate!,
    );

    if (validateProductionExist != null || validateExpiryExist != null) {
      context.snackBar(validateProductionExist ?? validateExpiryExist!);
      return;
    }
    if (validateExpiryValue != null) {
      context.snackBar(validateExpiryValue);
      return;
    }

    final newBatch = ProductBatchEntity(
      productId: widget.product.id,
      quantity: int.tryParse(_quantityController.text),
      purchasePrice: double.tryParse(_purchasePriceController.text),
      productionDate: _productionDate,
      expiryDate: _expiryDate,
    );

    log(newBatch.toString());

    context.snackBar(AppStrings.batchAddedSuccessfully);

    context.read<InventoryCubit>().restockProduct(newBatch);

    context.pop();
  }

  Future<void> _selectDate({
    required void Function(DateTime) onDateSelected,
  }) async {
    final now = DateTime.now();

    final DateTime? picked = await context.datePicker(
      initialDate: now,
      firstDate: now.subtract(_dateMargin),
      lastDate: now.add(_dateMargin),
    );

    if (picked == null) return;

    onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.restock} ${widget.product.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16.h,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                focusNode: _quantityFocusNode,
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: ValidationService.validateQuantity,
                decoration: InputDecoration(labelText: AppStrings.quantity),

                onFieldSubmitted: (value) {
                  _purchasePriceFocusNode.requestFocus();
                },
              ),

              TextFormField(
                focusNode: _purchasePriceFocusNode,
                controller: _purchasePriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: ValidationService.validatePrice,
                decoration: InputDecoration(
                  labelText: AppStrings.purchasePrice,
                ),
              ),

              const SizedBox.shrink(),

              BlocBuilder<AddBatchCubit, AddBatchState>(
                buildWhen:
                    (previous, current) =>
                        current is AddBatchProductoinDateSelected,
                builder: (context, state) {
                  return DatePickerWidget(
                    labelText: AppStrings.productionDate,
                    selectedDate: _productionDate,
                    onPressed:
                        () => _selectDate(
                          onDateSelected: (date) {
                            _productionDate = date;
                            context.read<AddBatchCubit>().selectProductionDate(
                              date,
                            );
                          },
                        ),
                  );
                },
              ),

              BlocBuilder<AddBatchCubit, AddBatchState>(
                buildWhen:
                    (previous, current) =>
                        current is AddBatchExpiryDateSelected,
                builder: (context, state) {
                  return DatePickerWidget(
                    labelText: AppStrings.expiryDate,
                    selectedDate: _expiryDate,
                    onPressed:
                        () => _selectDate(
                          onDateSelected: (date) {
                            _expiryDate = date;
                            context.read<AddBatchCubit>().selectExpiryDate(
                              date,
                            );
                          },
                        ),
                  );
                },
              ),

              const SizedBox.shrink(),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppStrings.addBatch),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
