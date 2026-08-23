import 'package:ensemble_table_calendar/ensemble_table_calendar.dart'
    as date_mixin;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';

class MyDatePickerFormField extends StatelessWidget {
  const MyDatePickerFormField({
    super.key,
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
    this.helperMessages,
    this.required,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.hidden = false,
    this.removeCalIcon = false,
    this.errorMessage,
    // required String? Function(dynamic value) validator,
  });
  final String name;
  final String label;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool readOnly;
  final Function(String?)? onChanged;
  final List<String>? helperMessages;
  final bool? required;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? hidden;
  final bool? removeCalIcon;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return hidden == true ? SizedBox.shrink(child: _date()) : _date();
  }

  Widget _date() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xs,
        horizontal: AppDimensions.xxs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: Get.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    Get
                        .textTheme
                        .bodySmall
                        ?.color, // Important: manually set color
              ),
              children: [
                TextSpan(
                  text: required == true ? ' *' : '',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.error, // Important: manually set color
                  ),
                ),
              ],
            ),
          ).paddingOnly(bottom: AppDimensions.xs),
          FormBuilderDateTimePicker(
            name: name,
            initialValue:
                initialValue != null
                    ? DateFormat('dd/MM/yyyy').parse(initialValue ?? '')
                    : null,
            format: DateFormat("dd/MM/yyyy"),
            firstDate: firstDate,
            lastDate: lastDate,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            inputType: InputType.date,
            enabled: !readOnly,
            // readOnly: readOnly,
            keyboardType: keyboardType,
            validator: validators(),
            onChanged:
                onChanged != null
                    ? (value) {
                      if (value != null) {
                        final initialValue =
                            Get.find<ProjectFunctionalController>()
                                .initialValue[name];
                        if (date_mixin.isSameDay(
                              initialValue is DateTime ? initialValue : null,
                              value,
                            ) ==
                            false) {
                          onChanged!(value.toString());
                        }
                      }
                    }
                    : null,
            style: Get.textTheme.titleSmall?.copyWith(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? AppColors.lightGrey : AppColors.textWhite,
              suffixIcon:
                  removeCalIcon == true
                      ? SizedBox.shrink()
                      : Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.newPrimary,
                      ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color:
                      readOnly == true ? AppColors.border : AppColors.lightGrey,
                  width: 1.5,
                ), // Remove default border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color: AppColors.newPrimary,
                  width: 1.5,
                ), // Optional: Custom border when focused
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide.none, // No border when disabled
              ),
            ),
          ),
          if (helperMessages != null && helperMessages!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  helperMessages!.map((message) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message,
                        style: AppTextTheme.bodyVSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  FormFieldValidator? validators() {
    List<FormFieldValidator> validators = [];
    if (readOnly == false && required == true) {
      validators.add(FormBuilderValidators.required(errorText: errorMessage));
    }
    return validators.isEmpty
        ? null
        : FormBuilderValidators.compose(validators);
  }
}
