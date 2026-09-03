import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/form_field_config.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/mixin/condition_validators.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/date_picker_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/forms_checkbox.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/my_radio_form_field.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/text_field.dart';

class SwitchFormFieldWidgets extends StatelessWidget with ConditionValidators {
  const SwitchFormFieldWidgets({
    super.key,
    required this.field,
    required this.controller,
    this.isShow = false,
  });
  final FormFieldConfig field;
  final ProjectFunctionalController controller;
  final bool? isShow;

  @override
  Widget build(BuildContext context) {
    return Obx(() => getFormField());
  }

  Widget getFormField() {
    switch (field.type) {
      case "text":
      case "textarea":
        return Visibility(
          visible: visibility(field, controller),
          child: MyFormBuilderTextField(
            name: field.name,
            label: field.label,
            infoMsg: field.info,
            initialValue: controller.initialValue[field.name]?.toString(),
            disable: disableWhen(field, controller.formKey, controller),
            keyboardType: field.keyboardType,
            maxValue: field.maxValue,
            maxLength: field.maxLength,
            validator: FormBuilderValidators.compose(
              bindValidations(
                field,
                field.validationMsg,
                disableWhen(field, controller.formKey, controller),
                controller,
              ),
            ),
            onChanged: (p0) {
              controller.onDynamicFormChanged();
            },
            required: field.required,
            isShowNoteMsg: field.isShowNoteMsg,
          ),
        );
      case "radio":
        return Visibility(
          visible: visibility(field, controller),
          child: MyRadioFormField(
            name: field.name,
            label: field.label,
            infoMsg: field.info,
            errorMessage: field.validationMsg,
            required: field.required == true ? true : false,
            options: field.options ?? [],
            initialValue: controller.initialValue[field.name],
            disable: disableWhen(field, controller.formKey, controller),
            validator: bindValidations(
              field,
              field.validationMsg,
              disableWhen(field, controller.formKey, controller),
              controller,
            ),
            onChange: (value) {
              controller.onDynamicFormChanged();
              // controller.showPopup(field, value);
              // controller.triggerRebuild(field);
              // if (field.buildWhenOptionChanged != null && value != null) {
              //   controller.updateDropdownOptions(field, value);
              // }
              // if (field.fetchAndPatchOnChange != null) {
              //   controller.fetchAndPatchOnChange(field, value);
              // }
            },
          ),
        );
      case "date":
        return Visibility(
          visible: visibility(field, controller),
          child: MyDatePickerFormField(
            hidden: field.hidden,
            name: field.name,
            label: field.label,
            initialValue: _parseDate(controller.initialValue[field.name]),
            errorMessage: field.validationMsg,
            required:
                field.required == true
                    ? true
                    : false, //!disableWhen(field, controller.formKey, controller),
            readOnly: disableWhen(field, controller.formKey, controller),
            onChanged: (value) {
              // if (controller.initialValue[field.name] != null) {
              //   controller.initialValue[field.name] = null;
              // }

              controller.onDynamicFormChanged();
            },
            firstDate: getStartDate(field: field, controller: controller),
            lastDate: getEndDate(field: field),
          ),
        );
      case "checkbox":
        return Visibility(
          visible: visibility(field, controller),
          child: FormsCheckbox(
            name: field.name,
            text: field.label,
            validator: FormBuilderValidators.compose(
              bindValidations(
                field,
                field.validationMsg ?? "This field cannot be empty.",
                disableWhen(field, controller.formKey, controller),
                controller,
              ),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value;
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    try {
      return DateFormat('dd/MM/yyyy').parse(stringValue);
    } catch (_) {
      return DateTime.tryParse(stringValue);
    }
  }
}
