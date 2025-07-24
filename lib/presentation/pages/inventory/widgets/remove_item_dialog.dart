import 'package:flutter/material.dart';
import 'package:supermarket/core/constants/app_strings.dart';

class RemoveItemDialogBody extends StatelessWidget {
  const RemoveItemDialogBody({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.confirmDeletion),
      content: Text(AppStrings.deleteProductConfirmation),
      actions: [
        TextButton(onPressed: onCancel, child: Text(AppStrings.cancel)),
        TextButton(onPressed: onConfirm, child: Text(AppStrings.delete)),
      ],
    );
  }
}
