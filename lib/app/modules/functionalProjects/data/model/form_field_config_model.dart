import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/form_field_config.dart';

class FormFieldConfigModel extends FormFieldConfig {
  FormFieldConfigModel({
    super.disable,
    super.visibleWhen,
    super.options,
    super.initialValue,
    super.disableWhen,
    super.value,
    super.info,
    super.clearFieldsOnChange,
    super.firstDateInCalendarFromResponseKey,
    super.noOfYearsAddInDobForStartdate,
    required super.name,
    required super.label,
    required super.type,
    super.fieldDisableFn,
    super.applicationDate,
    super.noOfYearsAddInDobForLastdate,
    super.hidden,
    super.firstDateInCalendarFromFormKey,
    super.apiPath,
    super.dropdownOptionsConfig,
    super.fieldQuery,
    super.required,
    super.buildWhenOptionChanged,
    super.fetchAndPatchOnChange,
    super.isPreview,
    super.excludeIds,
    super.canBeLocked,
    super.listConfig,
    super.requiredAllQueryKeys,
    super.validationMsg,
    super.updateOnFetch,
    super.maxValue,
    super.keyboardType,
    super.validateConfirmField,
    super.visibleWhenValidation,
    super.invalidWhen,
    super.isShowNoteMsg,
    super.skipBuildWhenOptionValueIs,
    super.codeConfig,
    super.inputBoxes,
    super.allowedCharacters,
    super.popupConfig,
    super.notAllowed,
  });

  factory FormFieldConfigModel.fromJson(
    Map<String, dynamic> json,
  ) => FormFieldConfigModel(
    isPreview: json["isPreview"],
    disable: json["disable"],
    //visibleWhen: json["visibleWhen"],
    visibleWhen:
        (json["visibleWhen"] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
    options:
        (json["options"] is List)
            ? (json["options"] as List)
                .map(
                  (e) =>
                      e is Map<String, dynamic>
                          ? e
                          : Map<String, dynamic>.from({}),
                )
                .toList()
            : null,
    initialValue: json["initialValue"],
    //disableWhen: json["disableWhen"],
    disableWhen:
        (json["disableWhen"] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
    name: json["name"],
    label: json["label"],
    type: json["type"],
    value: json["value"],
    //clearFieldsOnChange: json["clearFieldsOnChange"],
    clearFieldsOnChange:
        json["clearFieldsOnChange"] != null
            ? Map<String, dynamic>.from(json["clearFieldsOnChange"])
            : null,
    fieldDisableFn: json["fieldDisableFn"],
    info: json["info"],
    firstDateInCalendarFromResponseKey:
        json["firstDateInCalendarFromResponseKey"],
    noOfYearsAddInDobForStartdate: json["noOfYearsAddInDobForStartdate"],
    applicationDate: json["applicationDate"],
    noOfYearsAddInDobForLastdate: json["noOfYearsAddInDobForLastdate"],
    hidden: json["hidden"],
    firstDateInCalendarFromFormKey: json["firstDateInCalendarFromFormKey"],
    apiPath: json["apiPath"],
    required: json["required"],
    fieldQuery:
        (json["fieldQuery"] is List)
            ? (json["fieldQuery"] as List)
                .map((e) => FieldQuery.fromJson(e))
                .toList()
            : null,
    // fieldQuery: (json["fieldQuery"] as List?)
    //     ?.map((e) {
    //       final map = Map<String, dynamic>.from(e);
    //       return FieldQuery(
    //         queryKey: map["queryKey"],
    //         valueFromKey: map["valueFromKey"],
    //         valueFromCodeKey: map["valueFromCodeKey"],
    //       );
    //     })
    //     .toList(),
    dropdownOptionsConfig:
        json["dropdownOptionsConfig"] != null
            ? DropdownOptionsConfig(
              labelAppendKey: json["dropdownOptionsConfig"]["labelAppendKey"],
              labelKey: json["dropdownOptionsConfig"]["labelKey"],
              valueKey: json["dropdownOptionsConfig"]["valueKey"],
              dataInNestedObj: json["dropdownOptionsConfig"]["dataInNestedObj"],
            )
            : null,
    buildWhenOptionChanged: json["buildWhenOptionChanged"],
    // fetchAndPatchOnChange: json["fetchAndPatchOnChange"] != null
    //     ? FetchAndPatchOnChangeModel.fromJson(json["fetchAndPatchOnChange"])
    //     : null,
    fetchAndPatchOnChange:
        json["fetchAndPatchOnChange"] != null
            ? FetchAndPatchOnChangeModel.fromJson(
              Map<String, dynamic>.from(json["fetchAndPatchOnChange"]),
            )
            : null,
    //excludeIds: json["excludeIds"],
    excludeIds:
        (json["excludeIds"] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
    canBeLocked: json["canBeLocked"],
    // listConfig: json["listConfig"] != null
    //     ? ListConfigModel.fromJson(json["listConfig"])
    //     : null,
    listConfig:
        json["listConfig"] != null
            ? ListConfigModel.fromJson(
              Map<String, dynamic>.from(json["listConfig"]),
            )
            : null,
    requiredAllQueryKeys: json["requiredAllQueryKeys"],
    validationMsg: json["validationMsg"],
    // updateOnFetch: json["updateOnFetch"] != null
    //     ? FetchAndPatchOnChangeModel.fromJson(json["updateOnFetch"])
    //     : null,
    updateOnFetch:
        json["updateOnFetch"] != null
            ? FetchAndPatchOnChangeModel.fromJson(
              Map<String, dynamic>.from(json["updateOnFetch"]),
            )
            : null,
    maxValue: json["maxValue"],
    keyboardType: json["keyboardType"],
    validateConfirmField: json["validateConfirmField"],
    visibleWhenValidation: json["visibleWhenValidation"],
    invalidWhen: json["invalidWhen"],
    isShowNoteMsg: json["isShowNoteMsg"],
    skipBuildWhenOptionValueIs: json["skipBuildWhenOptionValueIs"],
    codeConfig:
        (json['codeConfig'] is List?)
            ? (json['codeConfig'] as List?)
                ?.map(
                  (e) => CodeConfig(
                    labelAppendKey: e["labelAppendKey"],
                    labelKey: e["labelKey"],
                    valueKey: e["valueKey"],
                  ),
                )
                .toList()
            : null,
    inputBoxes: json["inputBoxes"],
    allowedCharacters: json["allowedCharacters"],
    popupConfig:
        json["popupConfig"] == null
            ? null
            : PopupConfigModel.fromJson(json["popupConfig"]),
    notAllowed:
        (json["notAllowed"] is List)
            ? (json["notAllowed"] as List).map((e) => e.toString()).toList()
            : null,
  );
}

class ListConfigModel extends ListConfig {
  ListConfigModel({super.dynamicFormKeys});
  factory ListConfigModel.fromJson(Map<String, dynamic> json) =>
      ListConfigModel(
        dynamicFormKeys:
            (json["dynamicFormKeys"] as List?)
                ?.map(
                  (e) => DynamicFormKeys(
                    formKey: (e as Map<String, dynamic>)["formKey"],
                    type: e["type"],
                    label: e["label"],
                    options: e["options"],
                  ),
                )
                .toList(),
        // dynamicFormKeys:
        //     (json["dynamicFormKeys"] as List<Map<String, dynamic>>?)
        //         ?.map(
        //           (Map<String, dynamic>? e) => DynamicFormKeys(
        //             formKey: e?["formKey"],
        //             type: e?["type"],
        //             label: e?["label"],
        //             options: e?["options"],
        //           ),
        //         )
        //         .toList(),
      );
}

class FetchAndPatchOnChangeModel extends FetchAndPatchOnChange {
  FetchAndPatchOnChangeModel({
    super.apiPath,
    super.fieldQuery,
    super.patchFormKeys,
  });

  factory FetchAndPatchOnChangeModel.fromJson(Map<String, dynamic> json) =>
      FetchAndPatchOnChangeModel(
        apiPath: json["apiPath"],
        // fieldQuery: json["fieldQuery"] != null
        //     ? (json["fieldQuery"] as List<Map<String, dynamic>>)
        //         .map(
        //           (Map<String, dynamic>? e) => FieldQuery(
        //             queryKey: e?["queryKey"],
        //             valueFromKey: e?["valueFromKey"],
        //             valueFromCodeKey: e?["valueFromCodeKey"],
        //           ),
        //         )
        //         .toList()
        //     : null,
        fieldQuery:
            (json["fieldQuery"] as List?)?.map((e) {
              final map = Map<String, dynamic>.from(e);
              return FieldQuery(
                queryKey: map["queryKey"],
                valueFromKey: map["valueFromKey"],
                valueFromCodeKey: map["valueFromCodeKey"],
              );
            }).toList(),
        // patchFormKeys: json["patchFormKeys"] != null
        //     ? (json["patchFormKeys"] as List<Map<String, dynamic>>)
        //         .map(
        //           (Map<String, dynamic>? e) => PatchFormKeys(
        //             formKey: e?["formKey"],
        //             initialValue: e?["initialValue"],
        //             valueKey: e?["valueKey"],
        //           ),
        //         )
        //         .toList()
        //     : null
        patchFormKeys:
            (json["patchFormKeys"] as List?)?.map((e) {
              final map = Map<String, dynamic>.from(e);
              return PatchFormKeys(
                formKey: map["formKey"],
                initialValue: map["initialValue"],
                valueKey: map["valueKey"],
              );
            }).toList(),
      );
}

class PopupConfigModel extends PopupConfig {
  PopupConfigModel({super.enabled, super.msg, super.onValue});

  factory PopupConfigModel.fromJson(Map<String, dynamic> json) =>
      PopupConfigModel(
        enabled: json["enabled"],
        msg: (json["msg"] as List<dynamic>?)?.map((e) => e as String).toList(),
        onValue:
            (json["onValue"] as List<dynamic>?)
                ?.map((e) => e as dynamic)
                .toList(),
      );
}
