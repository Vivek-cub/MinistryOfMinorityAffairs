import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/form_body_small.dart';

import '../../../utils/assets.dart';
import 'info_text.dart';

class MyFormsDropdown<T> extends StatelessWidget {
  final String name;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool required;
  final bool enabled;
  final String? Function(T?)? validator;
  final String? label;
  final double? menuWidth;
  final String? infoMsg;
  final dynamic initialValue;
  final double labelFieldGap;
  const MyFormsDropdown({
    super.key,
    this.onChanged,
    this.required = true,
    this.enabled = true,
    this.validator,
    this.label,
    required this.name,
    required this.hintText,
    required this.items,
    this.menuWidth,
    this.infoMsg,
    this.initialValue,
    this.labelFieldGap = AppDimensions.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FormBodySmall(text: label ?? ''),
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
        SizedBox(height: labelFieldGap),
        FormBuilderDropdown<T>(
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          validator: validator,
          name: name,
          enabled: enabled,
          isDense: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          hint: FormBodySmall(text: hintText),
          padding: EdgeInsets.zero,
          icon: dropDownIcon(),
          iconSize: 50,
          menuMaxHeight: 400,
          menuWidth: menuWidth ?? MediaQuery.of(context).size.width * 0.90,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppColors.lightGrey,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: AppColors.textWhite,
          decoration: _inputDecoration,
          initialValue: initialValue,
        ),
        infoMsg != null ? InfoText(text: infoMsg ?? "") : SizedBox.shrink(),
      ],
    );
  }

  InputDecoration get _inputDecoration => InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.only(left: AppDimensions.md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      borderSide: BorderSide(color: AppColors.primaryLight),
    ),
    fillColor: enabled ? AppColors.textWhite : AppColors.lightGrey,
    filled: true,
    hintText: hintText,
    hintStyle: Get.textTheme.bodySmall?.copyWith(
      color: AppColors.lightGrey,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget dropDownIcon() {
    return Container(
      width: 50,
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppDimensions.sm),
          bottomRight: Radius.circular(AppDimensions.sm),
        ),
        border: Border(
          left: BorderSide(color: AppColors.primaryLight, width: 1),
        ),
      ),
      // child: Center(
      //   child: SvgPicture.asset(IconAssets.dr),
      // ),
    );
  }
}
