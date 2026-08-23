import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/model/form_field_config_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/dynamic_form_config.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/form_field_config.dart';

class DynamicFormConfigModel extends DynamicFormConfig {
  DynamicFormConfigModel({
    super.isFormData,
    required super.apiPaths,
    required super.fields,
  });
  factory DynamicFormConfigModel.fromJson(Map<String, dynamic> json) =>
      DynamicFormConfigModel(
        apiPaths: ApiPaths(
          get: json["apiPaths"]?["get"]?.toString() ?? '',
          post: json["apiPaths"]?["post"]?.toString() ?? '',
        ),
        isFormData: json["isFormData"],
        fields:
            json["fields"] != null
                ? (json["fields"] as List)
                    .map<FormFieldConfig>(
                      (field) => FormFieldConfigModel.fromJson(
                        Map<String, dynamic>.from(field),
                      ),
                    )
                    .toList()
                : [],
        // fields: json["fields"] != null
        //     ? (json["fields"] as List<Map<String, dynamic>>)
        //         .map<FormFieldConfig>(
        //           (field) => FormFieldConfigModel.fromJson(field),
        //         )
        //         .toList()
        //     : [],
      );
}
