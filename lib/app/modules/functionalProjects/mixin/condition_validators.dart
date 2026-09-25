import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';

mixin ConditionValidators {
  // ===========================================================================
  // VISIBILITY
  // ===========================================================================

  bool visibility(
    FunctionalQuestion question,
    FunctionalController controller,
  ) {
    final conditions = question.visibleWhen;

    // No visibleWhen condition = always visible
    if (conditions == null || conditions.isEmpty) {
      return true;
    }

    for (final condition in conditions) {
      final key = condition.key;

      if (key == null || key.trim().isEmpty) {
        continue;
      }

      final actualValue = controller.dynamicFormValue[key];
      final expectedValue = condition.value;

      final isMatch = _valuesEqual(actualValue, expectedValue);

      debugPrint('==========================================');
      debugPrint('VISIBILITY CHECK');
      debugPrint('Question      : ${question.questionId}');
      debugPrint('Depends On    : $key');
      debugPrint('Actual Value  : $actualValue');
      debugPrint('Expected      : $expectedValue');
      debugPrint('Actual Type   : ${actualValue.runtimeType}');
      debugPrint('Expected Type : ${expectedValue.runtimeType}');
      debugPrint('Normalized    : ${_normalize(actualValue)}');
      debugPrint('Expected Norm : ${_normalize(expectedValue)}');
      debugPrint('Result        : $isMatch');
      debugPrint('==========================================');

      if (!isMatch) {
        return false;
      }
    }

    return true;
  }

  // ===========================================================================
  // VALUE COMPARISON
  // ===========================================================================

  bool _valuesEqual(dynamic actual, dynamic expected) {
    final normalizedActual = _normalize(actual);
    final normalizedExpected = _normalize(expected);

    return normalizedActual == normalizedExpected;
  }

  // ===========================================================================
  // NORMALIZE
  // ===========================================================================

  dynamic _normalize(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      switch (normalized) {
        case 'true':
        case 'yes':
          return true;

        case 'false':
        case 'no':
          return false;

        default:
          return normalized;
      }
    }

    if (value is num) {
      return value;
    }

    return value;
  }

  // ===========================================================================
  // DISABLE
  // ===========================================================================

  bool disableWhen(
    FunctionalQuestion question,
    GlobalKey<FormBuilderState> formKey,
    FunctionalController? controller,
  ) {
    return false;
  }

  // ===========================================================================
  // FIELD DISABLE
  // ===========================================================================

  bool fieldDisableFunction(
    FunctionalQuestion question,
    GlobalKey<FormBuilderState> formKey,
  ) {
    return false;
  }

  // ===========================================================================
  // VALIDATIONS
  // ===========================================================================

  List<FormFieldValidator> bindValidations(
    FunctionalQuestion question,
    String? errorMessage,
    bool? disable,
    FunctionalController? controller,
  ) {
    errorMessage ??= 'This field cannot be empty.';

    if (errorMessage.isEmpty) {
      errorMessage = 'This field cannot be empty.';
    }

    final List<FormFieldValidator> validators = [];

    if (disable != true && question.isMandatory == true) {
      validators.add(FormBuilderValidators.required(errorText: errorMessage));
    }

    if (question.questionType?.toUpperCase() == 'INTEGER') {
      validators.add((value) {
        if (value == null || value.toString().trim().isEmpty) {
          return null;
        }

        if (int.tryParse(value.toString().trim()) == null) {
          return 'Please enter a valid number.';
        }

        return null;
      });
    }

    return validators;
  }

  // ===========================================================================
  // CLEAR DEPENDENT FIELDS
  // ===========================================================================

  void clearFieldsOnChange(
    FunctionalQuestion question,
    FunctionalController controller,
  ) {
    // Implement if dependent values should be cleared
    // when their visibility condition becomes false.
  }

  // ===========================================================================
  // NULL / EMPTY
  // ===========================================================================

  bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  // ===========================================================================
  // START DATE
  // ===========================================================================

  DateTime? getStartDate({
    required FunctionalQuestion question,
    required FunctionalController controller,
  }) {
    return null;
  }

  // ===========================================================================
  // END DATE
  // ===========================================================================

  DateTime? getEndDate({
    required FunctionalQuestion question,
    Map<String, dynamic>? initialValues,
  }) {
    return null;
  }

  // ===========================================================================
  // PARSE FLEXIBLE DATE
  // ===========================================================================

  DateTime? parseFlexibleDate(String dateStr) {
    final normalized = dateStr.trim().replaceAll(RegExp(r'[\/\.]'), '-');

    final parts = normalized.split('-');

    if (parts.length != 3) {
      return null;
    }

    final p0 = int.tryParse(parts[0]);
    final p1 = int.tryParse(parts[1]);
    final p2 = int.tryParse(parts[2]);

    if (p0 == null || p1 == null || p2 == null) {
      return null;
    }

    // yyyy-MM-dd
    if (p0 > 31) {
      return DateTime.tryParse('$p0-${_pad(p1)}-${_pad(p2)}');
    }

    // dd-MM-yyyy
    if (p2 > 31) {
      return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
    }

    // MM-dd-yyyy
    if (p0 <= 12 && p1 > 12) {
      return DateTime.tryParse('$p2-${_pad(p0)}-${_pad(p1)}');
    }

    // dd-MM-yyyy
    if (p1 <= 12 && p0 > 12) {
      return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
    }

    // Default dd-MM-yyyy
    return DateTime.tryParse('$p2-${_pad(p1)}-${_pad(p0)}');
  }

  String _pad(int n) {
    return n.toString().padLeft(2, '0');
  }
}
