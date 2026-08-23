import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/form_field_config.dart';

class DynamicFormConfig {
  DynamicFormConfig({
    this.isFormData = false,
    required this.apiPaths,
    required this.fields,
  });

  final ApiPaths apiPaths;
  final bool? isFormData;
  final List<FormFieldConfig> fields;
}

class ApiPaths {
  ApiPaths({required this.get, required this.post});
  final String get;
  final String post;
}
