import 'package:flutter/material.dart';
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

  String get fieldName => 'question_${question.questionId}';

  // ---------------------------------------------------------------------------
  // Build: Obx ONLY when the question has a condition (an Obx that reads no
  // observable throws in GetX).
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final hasCondition = question.visibleWhen?.isNotEmpty ?? false;

    if (!hasCondition) return _content();

    return Obx(() {
      if (!visibility(question, controller)) {
        return const SizedBox.shrink();
      }
      return _content();
    });
  }

  Widget _content() {
    if (question.questionType == 'HEADING') return _buildHeading();
    return _buildQuestion();
  }

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

  // HEADING
  Widget _buildHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        question.questionText ?? '',
        style: Get.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  // YES / NO
  Widget _buildYesNo() {
    return MyRadioFormField(
      name: fieldName,
      label: question.questionText,
      required: question.isMandatory == true,
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
      },
    );
  }

  // TEXT
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

  // INTEGER
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

  // DATE
  Widget _buildDate() {
    return MyDatePickerFormField(
      name: fieldName,
      label: question.questionText ?? '',
      initialValue: _parseDate(question.answer, question.dateFormat),
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

  // DROPDOWN
  Widget _buildDropdown() {
    final items =
        (question.option ?? [])
            .map(
              (o) => DropdownMenuItem<String>(
                value: o.optionValue,
                child: Text(o.optionValue ?? ''),
              ),
            )
            .where((i) => i.value != null && i.value!.isNotEmpty)
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
              ? (value) =>
                  (value == null || value.isEmpty)
                      ? 'Please select an option'
                      : null
              : null,
      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // CHECKBOX  (FormsCheckbox must expose onChanged and pass it to the field)
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
      // onChanged: (value) {
      //   controller.onQuestionValueChanged(question.questionId!, value);
      // },
    );
  }

  // IMAGE
  Widget _buildImages() {
    return CaptureImageFormField(
      name: fieldName,
      label: question.questionText ?? '',
      initialValue: question.answer?.toString(),
      required: question.isMandatory == true,
      validator:
          question.isMandatory == true
              ? (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Please capture an image'
                      : null
              : null,
      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

  // VIDEO
  Widget _buildVideo() {
    return CaptureVideoFormField(
      name: fieldName,
      label: question.questionText ?? '',
      initialValue: question.answer?.toString(),
      required: question.isMandatory == true,
      validator:
          question.isMandatory == true
              ? (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Please capture a video'
                      : null
              : null,
      onCapture: () async => await controller.captureVideoForForm(),
      onChanged: (value) {
        controller.onQuestionValueChanged(question.questionId!, value);
      },
    );
  }

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
          value.trim().isNotEmpty &&
          int.tryParse(value.trim()) == null) {
        return 'Please enter a valid number';
      }
      return null;
    };
  }

  bool? _normalizeBoolean(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'true' || v == 'yes') return true;
      if (v == 'false' || v == 'no') return false;
    }
    return null;
  }

  DateTime? _parseDate(dynamic value, String? dateFormat) {
    if (value == null) return null;
    if (value is DateTime) return value;

    final s = value.toString().trim();
    if (s.isEmpty) return null;

    if (dateFormat != null && dateFormat.isNotEmpty) {
      try {
        return DateFormat(dateFormat).parse(s);
      } catch (_) {}
    }
    for (final f in ['dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd']) {
      try {
        return DateFormat(f).parse(s);
      } catch (_) {}
    }
    return DateTime.tryParse(s);
  }
}
