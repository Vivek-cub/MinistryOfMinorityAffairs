class FormFieldConfig {
  FormFieldConfig({
    this.disable,
    this.visibleWhen,
    this.options,
    this.initialValue,
    this.disableWhen,
    this.value,
    this.required,
    this.info,
    this.clearFieldsOnChange,
    this.firstDateInCalendarFromResponseKey,
    this.noOfYearsAddInDobForStartdate,
    required this.name,
    required this.label,
    required this.type,
    this.fieldDisableFn,
    this.applicationDate,
    this.noOfYearsAddInDobForLastdate,
    this.hidden = false,
    this.firstDateInCalendarFromFormKey,
    this.apiPath,
    this.fieldQuery,
    this.dropdownOptionsConfig,
    this.buildWhenOptionChanged,
    this.fetchAndPatchOnChange,
    this.isPreview,
    this.excludeIds,
    this.canBeLocked,
    this.listConfig,
    this.requiredAllQueryKeys,
    this.validationMsg,
    this.updateOnFetch,
    this.maxValue,
    this.maxLength,
    this.keyboardType,
    this.validateConfirmField,
    this.visibleWhenValidation,
    this.invalidWhen,
    this.isShowNoteMsg,
    this.skipBuildWhenOptionValueIs,
    this.codeConfig,
    this.inputBoxes,
    this.allowedCharacters,
    this.popupConfig,
    this.notAllowed,
  });
  final String name;
  final String label;
  final String type;
  final String? value;
  final bool? disable;
  final bool? required;
  final String? info;
  final List<Map<String, dynamic>>? visibleWhen;
  final List<dynamic>? options;
  final String? initialValue;
  final List<Map<String, dynamic>>? disableWhen;
  final Map<String, dynamic>? clearFieldsOnChange;
  final String? firstDateInCalendarFromResponseKey;
  final String? firstDateInCalendarFromFormKey;
  final int? noOfYearsAddInDobForStartdate;
  final String? fieldDisableFn;
  final String? applicationDate;
  final int? noOfYearsAddInDobForLastdate;
  final bool? hidden;
  final String? apiPath;
  final List<FieldQuery>? fieldQuery;
  final DropdownOptionsConfig? dropdownOptionsConfig;
  final String? buildWhenOptionChanged;
  final List<Map<String, dynamic>>? excludeIds;
  final FetchAndPatchOnChange? fetchAndPatchOnChange;
  final bool? isPreview;
  final String? canBeLocked;
  final ListConfig? listConfig;
  final bool? requiredAllQueryKeys;
  final String? validationMsg;
  final FetchAndPatchOnChange? updateOnFetch;
  final int? maxValue;
  final int? maxLength;
  final String? keyboardType;
  final String? validateConfirmField;
  final String? visibleWhenValidation;
  final String? invalidWhen;
  final bool? isShowNoteMsg;
  final dynamic skipBuildWhenOptionValueIs;
  final List<CodeConfig>? codeConfig;
  final int? inputBoxes;
  final String? allowedCharacters;
  final PopupConfig? popupConfig;
  final List<String>? notAllowed;
}

class FieldQuery {
  String? queryKey;
  String? valueFromKey;
  String? valueFromCodeKey;
  FieldQuery({this.queryKey, this.valueFromKey, this.valueFromCodeKey});
  factory FieldQuery.fromJson(Map<String, dynamic> json) => FieldQuery(
    queryKey: json["queryKey"],
    valueFromKey: json["valueFromKey"],
    valueFromCodeKey: json["valueFromCodeKey"],
  );
}

class DropdownOptionsConfig {
  DropdownOptionsConfig({
    this.labelKey,
    this.labelAppendKey,
    this.valueKey,
    this.dataInNestedObj,
  });
  final String? labelKey;
  final String? labelAppendKey;
  final String? valueKey;
  final String? dataInNestedObj;
  factory DropdownOptionsConfig.fromJson(Map<String, dynamic> json) =>
      DropdownOptionsConfig(
        labelKey: json['labelKey'],
        labelAppendKey: json['labelAppendKey'],
        valueKey: json['valueKey'],
        dataInNestedObj: json['dataInNestedObj'],
      );
}

class FetchAndPatchOnChange {
  FetchAndPatchOnChange({this.apiPath, this.fieldQuery, this.patchFormKeys});
  final String? apiPath;
  final List<FieldQuery>? fieldQuery;
  final List<PatchFormKeys>? patchFormKeys;
  factory FetchAndPatchOnChange.fromJson(
    Map<String, dynamic> json,
  ) => FetchAndPatchOnChange(
    apiPath: json['apiPath'],
    fieldQuery:
        (json['fieldQuery'] is List)
            ? (json['fieldQuery'] as List)
                .map((e) => FieldQuery.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : null,
    patchFormKeys:
        (json['patchFormKeys'] is List)
            ? (json['patchFormKeys'] as List)
                .map(
                  (e) => PatchFormKeys.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
            : null,
  );
}

class PatchFormKeys {
  PatchFormKeys({this.formKey, this.initialValue, this.valueKey});
  final String? formKey;
  final dynamic initialValue;
  final String? valueKey;
  factory PatchFormKeys.fromJson(Map<String, dynamic> json) => PatchFormKeys(
    formKey: json["formKey"],
    initialValue: json["initialValue"],
    valueKey: json["valueKey"],
  );
}

class ListConfig {
  final List<DynamicFormKeys>? dynamicFormKeys;
  ListConfig({this.dynamicFormKeys});
  factory ListConfig.fromJson(Map<String, dynamic> json) => ListConfig(
    dynamicFormKeys:
        (json['dynamicFormKeys'] is List)
            ? (json['dynamicFormKeys'] as List)
                .map(
                  (e) => DynamicFormKeys.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
            : null,
  );
}

class DynamicFormKeys {
  DynamicFormKeys({this.formKey, this.type, this.label, this.options});
  final String? formKey;
  final String? label;
  final String? type;
  final List<dynamic>? options;
  factory DynamicFormKeys.fromJson(Map<String, dynamic> json) =>
      DynamicFormKeys(
        formKey: json['formKey'],
        label: json['label'],
        type: json['type'],
        options: (json['options'] is List) ? (json['options'] as List) : null,
      );
}

class CodeConfig extends DropdownOptionsConfig {
  CodeConfig({super.labelKey, super.valueKey, super.labelAppendKey});
}

class PopupConfig {
  final bool? enabled;
  final List<String?>? msg;
  final List<dynamic>? onValue;
  PopupConfig({this.enabled, this.msg, this.onValue});
}
