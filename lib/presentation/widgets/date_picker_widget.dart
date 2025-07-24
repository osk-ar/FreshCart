import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/utils/extensions.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onPressed,
  });

  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDate == null
                ? labelText
                : '$labelText: ${DateFormat.yMd().format(selectedDate!)}',
            style: context.theme.textTheme.bodyLarge,
          ),
        ),
        TextButton(onPressed: onPressed, child: Text(AppStrings.selectDate)),
      ],
    );
  }
}
