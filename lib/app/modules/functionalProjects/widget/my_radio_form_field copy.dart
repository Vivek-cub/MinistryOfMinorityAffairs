import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/info_text.dart';

class MyRadioFormField extends StatelessWidget {
  const MyRadioFormField({
    super.key,
    this.label,
    required this.name,
    required this.options,
    this.required,
    this.onChange,
    this.disable = false,
    this.infoMsg,
    this.errorMessage,
    required this.validator,
  });
  final String name;
  final List<dynamic> options;
  final String? label;
  final Function(dynamic value)? onChange;
  final bool? required;
  final bool disable;
  final String? infoMsg;
  final String? errorMessage;
  final List<FormFieldValidator> validator;

  @override
  Widget build(BuildContext context) {
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
              text: label ?? "",
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
          infoMsg != null ? InfoText(text: infoMsg ?? "") : SizedBox.shrink(),
          FormBuilderRadioGroup(
            name: name,
            enabled: !disable,
            validator: FormBuilderValidators.compose(validator),
            onChanged: (value) {
              if (onChange != null) {
                onChange!(value);
              }
            },
            options: List.generate(
              options.length,
              (index) => FormBuilderFieldOption(
                value: options[index]["value"],
                child: Text(
                  options[index]["label"],
                  style: Get.textTheme.titleSmall?.copyWith(
                    color:
                        disable == false
                            ? AppColors.primary
                            : AppColors.lightGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  // FormFieldValidator? validators() {
  //   List<FormFieldValidator> validators = [];
  //   if (disable == false && required == true) {
  //     validators.add(
  //       FormBuilderValidators.required(errorText: errorMessage),
  //     );
  //   }
  //   return validators.isEmpty
  //       ? null
  //       : FormBuilderValidators.compose(validators);
  // }
}
