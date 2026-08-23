import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/form_field_config.dart';

mixin ConditionValidators {
  // bool visibility(FormFieldConfig field, GlobalKey<FormBuilderState> formKey) {
  //   if (field.visibleWhen?.isNotEmpty == true) {
  //     for (var condition in field.visibleWhen ?? []) {
  //       if (formKey.currentState?.fields[condition['key']]?.value == null) {
  //         return false;
  //       }
  //       if (field.visibleWhenValidation != null) {
  //         if (field.visibleWhenValidation == "notEqual") {
  //           if (formKey.currentState?.fields[condition['key']]?.value == null) {
  //             return false;
  //           }
  //           if ((formKey.currentState?.fields[condition['key']]?.value
  //                       as String?)
  //                   ?.trim() ==
  //               (condition['value'] as String?)?.trim()) {
  //             return false;
  //           }
  //         }
  //       } else {
  //         if (formKey.currentState?.fields[condition['key']]?.value !=
  //             condition['value']) {
  //           return false;
  //         }
  //       }
  //     }
  //   }

  //   return true;
  // }

  bool visibility(
    FormFieldConfig field,
    ProjectFunctionalController controller,
  ) {
    final conditions = field.visibleWhen;

    if (conditions == null || conditions.isEmpty) {
      return true;
    }

    for (final condition in conditions) {
      final key = condition['key']?.toString();
      final expectedValue = condition['value'];

      if (key == null) {
        continue;
      }

      final actualValue = controller.dynamicFormValue[key];

      debugPrint(
        'Visibility -> field: ${field.name}, '
        'key: $key, '
        'actual: $actualValue (${actualValue.runtimeType}), '
        'expected: $expectedValue (${expectedValue.runtimeType})',
      );

      if (field.visibleWhenValidation == "notEqual") {
        if (_normalize(actualValue) == _normalize(expectedValue)) {
          return false;
        }
      } else {
        if (_normalize(actualValue) != _normalize(expectedValue)) {
          return false;
        }
      }
    }

    return true;
  }

  dynamic _normalize(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final v = value.trim();

      if (v.toLowerCase() == 'true') return true;
      if (v.toLowerCase() == 'false') return false;

      return v;
    }

    return value;
  }

  bool disableWhen(
    FormFieldConfig field,
    GlobalKey<FormBuilderState> formKey,
    ProjectFunctionalController? controller,
  ) {
    if (field.disable == true) return true;
    return false;
  }

  bool fieldDisableFunction(
    FormFieldConfig field,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return false;
  }

  List<FormFieldValidator> bindValidations(
    FormFieldConfig field,
    String? errorMessage,
    bool? disable,
    ProjectFunctionalController? controller,
  ) {
    if (errorMessage?.isEmpty == true) {
      errorMessage = "This field cannot be empty.";
    }
    List<FormFieldValidator> validator = [];
    if (disable == false && field.required == true) {
      validator.add(FormBuilderValidators.required(errorText: errorMessage));
    }
    if (field.invalidWhen != null) {
      validator.add((value) {
        if (value.toString() == field.invalidWhen) {
          return errorMessage;
        }
        return null;
      });
    }
    if (field.maxValue != null) {
      validator.add((value) {
        final raw = value?.toString().trim();

        if (raw == null || raw.isEmpty) {
          return null;
        }

        final numValue = num.tryParse(raw);
        if ((numValue == null) ||
            (numValue < 0 || numValue > field.maxValue!)) {
          String fieldName = field.name;
          if (fieldName.toLowerCase().contains('percentage')) {
            fieldName = 'Percentage';
          } else if (fieldName.toLowerCase().contains('cgpa')) {
            fieldName = 'CGPA';
          }
          return '$fieldName must be between 0 and ${field.maxValue}';
        }

        return null;
      });
    }

    if (field.name == "percentage" && field.label.contains('COVID-19')) {
      validator.add((value) {
        final String? rawValue = value?.toString().trim();
        if (rawValue == null || rawValue.isEmpty) {
          return null;
        }
        final RegExp pattern = RegExp(
          r'^(NA|100(\.0{0,2})?|\d{1,2}(\.\d{0,2})?)?$',
        );
        if (!pattern.hasMatch(value)) {
          return 'Invalid Percentage (e.g. 85.66)';
        }
        return null;
      });
    }

    return validator;
  }

  void clearFieldsOnChange(
    FormFieldConfig field,
    ProjectFunctionalController controller,
  ) {}

  bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  DateTime? getStartDate({
    required FormFieldConfig field,
    required ProjectFunctionalController controller,
  }) {
    return null;
  }

  DateTime? getEndDate({
    required FormFieldConfig field,
    Map<String, dynamic>? initialValues,
  }) {
    final int? yearsToAdd = field.noOfYearsAddInDobForLastdate;
    if (yearsToAdd == 0) {
      return DateTime.now();
    }
    if (field.applicationDate == null || yearsToAdd == null) {
      return null;
    }
    final String? dateString = field.applicationDate;
    if (dateString == null || dateString.isEmpty) return null;
    try {
      DateTime? parsedDate;

      parsedDate = parseFlexibleDate(dateString);

      final DateTime resultDate = DateTime(
        (parsedDate?.year ?? 0) + (yearsToAdd > 98 ? 0 : yearsToAdd),
        (parsedDate?.month ?? 0),
        (parsedDate?.day ?? 0),
      );
      //debugPrint(resultDate.toString());
      return resultDate;
    } catch (e) {
      return null;
    }
  }

  DateTime? parseFlexibleDate(String dateStr) {
    String normalized = dateStr.replaceAll(RegExp(r'[\/\.]'), '-');
    List<String> parts = normalized.split('-');
    if (parts.length != 3) return null;

    int? p0 = int.tryParse(parts[0]);
    int? p1 = int.tryParse(parts[1]);
    int? p2 = int.tryParse(parts[2]);

    if (p0 == null || p1 == null || p2 == null) return null;

    if (p0 > 31) {
      return DateTime.tryParse('$p0-${_pad(p1)}-${_pad(p2)}');
    } else if (p2 > 31) {
      return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
    } else {
      if (p0 <= 12 && p1 > 12) {
        return DateTime.tryParse('$p2-${_pad(p0)}-${_pad(p1)}');
      } else if (p1 <= 12 && p0 > 12) {
        return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
      } else {
        return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
      }
    }
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}
