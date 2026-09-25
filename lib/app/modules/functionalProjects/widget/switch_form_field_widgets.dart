import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';

import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/widget/capture_image_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/widget/capture_video_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/mixin/condition_validators.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/date_picker_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/forms_checkbox.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/forms_dropdown.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/my_radio_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/text_field.dart';

class SwitchFormFieldWidgets extends StatelessWidget with ConditionValidators {
  const SwitchFormFieldWidgets({
    super.key,
    required this.question,
    required this.controller,
  });

  final FunctionalQuestion question;
  final FunctionalController controller;

  // ---------------------------------------------------------------------------
  // FormBuilder field name
  // ---------------------------------------------------------------------------

  String get fieldName {
    return 'question_${question.questionId}';
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (question.questionType == 'HEADING') {
      return _buildHeading();
    }

    // Check API visibleWhen condition.
    if (!visibility(question, controller)) {
      return const SizedBox.shrink();
    }

    return _buildQuestion();
  }

  // ---------------------------------------------------------------------------
  // Question type switch
  // ---------------------------------------------------------------------------

  Widget _buildQuestion() {
    switch (question.questionType) {
      case 'YES_NO':
        return _buildYesNo();

      case 'TEXT':
        return _buildText();

      case 'INTEGER':
        return _buildInteger();

      case 'DATE':
        return _buildDate();

      case 'DROPDOWN':
        return _buildDropdown();

      case 'CHECKBOX':
        return _buildCheckbox();

      case 'HEADING':
        return _buildHeading();

      case 'IMAGE':
      case 'IMAGES':
        return _buildImages();

      case 'VIDEO':
        return _buildVideo();

      default:
        debugPrint('Unsupported question type: ${question.questionType}');

        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // HEADING
  // ---------------------------------------------------------------------------

  Widget _buildHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        question.questionText ?? '',
        style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // YES / NO
  // ---------------------------------------------------------------------------

  Widget _buildYesNo() {
    return MyRadioFormField(
      name: fieldName,

      label: question.questionText,

      required: question.isMandatory == true,

      /*
       * Your MyRadioFormField expects:
       *
       * [
       *   {
       *     "value": true,
       *     "label": "Yes"
       *   },
       *   {
       *     "value": false,
       *     "label": "No"
       *   }
       * ]
       */
      options: const [
        {'value': true, 'label': 'Yes'},
        {'value': false, 'label': 'No'},
      ],

      initialValue: _normalizeBoolean(question.answer),

      disable: false,

      errorMessage: 'Please select Yes or No',

      validator: bindValidations(
        question,
        'Please select Yes or No',
        false,
        controller,
      ),

      onChange: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);

        /*
         * Rebuild fields which depend on this question.
         */
        controller.update();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT
  // ---------------------------------------------------------------------------

  Widget _buildText() {
    return MyFormBuilderTextField(
      name: fieldName,

      label: question.questionText ?? '',

      initialValue: question.answer?.toString(),

      maxLength: question.maxLength,

      required: question.isMandatory == true,

      disable: false,

      keyboardType: 'text',

      validator: _validator(),

      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // INTEGER
  // ---------------------------------------------------------------------------

  Widget _buildInteger() {
    return MyFormBuilderTextField(
      name: fieldName,

      label: question.questionText ?? '',

      initialValue: question.answer?.toString(),

      maxLength: question.maxLength,

      required: question.isMandatory == true,

      disable: false,

      keyboardType: 'number',

      validator: _validator(),

      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DATE
  // ---------------------------------------------------------------------------

  Widget _buildDate() {
    final date = _parseDate(question.answer, question.dateFormat);

    return MyDatePickerFormField(
      name: fieldName,

      label: question.questionText ?? '',

      initialValue: date,

      required: question.isMandatory == true,

      readOnly: false,

      hidden: false,

      firstDate: DateTime(1900),

      lastDate: DateTime(2100),

      errorMessage: 'Please select a date',

      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DROPDOWN
  // ---------------------------------------------------------------------------

  Widget _buildDropdown() {
    final options = question.option ?? [];

    final items =
        options
            .map(
              (option) => DropdownMenuItem<String>(
                value: option.optionValue,
                child: Text(option.optionValue ?? ''),
              ),
            )
            .where((item) => item.value != null && item.value!.isNotEmpty)
            .toList();

    return MyFormsDropdown<String>(
      name: fieldName,
      label: question.questionText ?? '',
      hintText: 'Select ${question.questionText ?? ''}',
      items: items,
      initialValue: question.answer?.toString(),
      required: question.isMandatory == true,
      enabled: true,
      validator:
          question.isMandatory == true
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              }
              : null,
      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }
  // ---------------------------------------------------------------------------
  // CHECKBOX
  // ---------------------------------------------------------------------------

  Widget _buildCheckbox() {
    return FormsCheckbox(
      name: fieldName,

      text: question.questionText ?? '',

      initialValue: question.answer is bool ? question.answer : false,

      validator: (value) {
        if (question.isMandatory == true && value != true) {
          return 'This field is required';
        }

        return null;
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Image
  // ---------------------------------------------------------------------------

  Widget _buildImages() {
    return CaptureImageFormField(
      name: fieldName,
      label: question.questionText ?? '',
      initialValue: question.answer?.toString(),
      required: question.isMandatory == true,

      validator:
          question.isMandatory == true
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please capture an image';
                }

                return null;
              }
              : null,

      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }
  // ---------------------------------------------------------------------------
  // Image
  // ---------------------------------------------------------------------------

  Widget _buildVideo() {
    return CaptureVideoFormField(
      name: fieldName,
      label: question.questionText ?? '',
      initialValue: question.answer?.toString(),
      required: question.isMandatory == true,

      validator:
          question.isMandatory == true
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please capture a video';
                }

                return null;
              }
              : null,

      onCapture: () async {
        return await controller.captureVideoForForm();
      },

      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Validator
  // ---------------------------------------------------------------------------

  String? Function(String?)? _validator() {
    if (question.isMandatory != true && question.questionType != 'INTEGER') {
      return null;
    }

    return (value) {
      if (question.isMandatory == true &&
          (value == null || value.trim().isEmpty)) {
        return 'This field is required';
      }

      if (question.questionType == 'INTEGER' &&
          value != null &&
          value.trim().isNotEmpty) {
        if (int.tryParse(value.trim()) == null) {
          return 'Please enter a valid number';
        }
      }

      return null;
    };
  }

  // ---------------------------------------------------------------------------
  // Boolean normalization
  // ---------------------------------------------------------------------------

  bool? _normalizeBoolean(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is String) {
      if (value.toLowerCase() == 'true') {
        return true;
      }

      if (value.toLowerCase() == 'false') {
        return false;
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Date parsing
  // ---------------------------------------------------------------------------

  DateTime? _parseDate(dynamic value, String? dateFormat) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final String dateString = value.toString().trim();

    if (dateString.isEmpty) {
      return null;
    }

    /*
     * First use the format supplied by API.
     *
     * Example:
     * dateFormat = "dd-MM-yyyy"
     */
    if (dateFormat != null && dateFormat.isNotEmpty) {
      try {
        return DateFormat(dateFormat).parse(dateString);
      } catch (_) {}
    }

    /*
     * Fallback formats.
     */
    final formats = ['dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'];

    for (final format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (_) {}
    }

    return DateTime.tryParse(dateString);
  }
}
