import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/skill_development_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/model/dynamic_form_config_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/dynamic_form_config.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/repo/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/capture_image_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/geofence_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class ProjectFunctionalController extends GetxController
    with
        SnackBarMixin,
        PopupMixin,
        CompressMixin,
        CaptureImageMixin,
        GeofenceMixin {
  ProjectFunctionalController(
    this.captureProjectVideo,
    this.repo,
    this.repository,
    this.authService,
  );

  final CaptureProjectVideo captureProjectVideo;
  final ProjectFunctionalRepo repo;
  final SubmissionRepository repository;
  final AuthService authService;

  final RxnBool isFunctionalProject = RxnBool();
  final timelineController = TextEditingController();
  final RxInt finishedPercentage = 0.obs;
  final RxBool isFinishedPercentageAnswered = false.obs;
  final RxnBool stillWorkingOnProject = RxnBool();
  final RxString videoPath = ''.obs;
  final RxBool isSubmitting = false.obs;
  final Rx<UnitDetails> data = UnitDetails().obs;
  final RxString projectId = ''.obs;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  RxMap<String, dynamic> initialValue = RxMap();
  final Rxn<DynamicFormConfig> dynamicFormConfig = Rxn<DynamicFormConfig>();
  final RxString dynamicFormHeading = ''.obs;
  final RxMap<String, dynamic> dynamicFormValue = RxMap<String, dynamic>();

  @override
  RxDouble userLat = 0.0.obs;

  @override
  RxDouble userLng = 0.0.obs;

  @override
  RxBool isInsideFence = false.obs;
  RxBool isFunctional = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? UnitDetails();
      projectId.value = data.value.id ?? '';
      isFunctional.value = args['isFunctional'] ?? false;
      if (isFunctional.value == true) {
        selectFunctionalProject(isFunctional.value);
      }
      debugPrint("project Id: ${projectId.value}");
    }
    _loadCurrentForm();
  }

  void _loadDynamicForm({
    required Map<String, dynamic> formConfig,
    required Map<String, dynamic> initialValues,
  }) {
    final config = Map<String, dynamic>.from(formConfig);

    final fields = List<Map<String, dynamic>>.from(config['fields'] ?? []);

    for (final field in fields) {
      final fieldName = field['name']?.toString();

      if (fieldName != null && initialValues.containsKey(fieldName)) {
        field['value'] = initialValues[fieldName];
      }
    }

    config['fields'] = fields;

    dynamicFormHeading.value = config['pageHeading']?.toString() ?? '';

    dynamicFormConfig.value = DynamicFormConfigModel.fromJson(config);

    initialValue.value = Map<String, dynamic>.from(initialValues);

    dynamicFormValue.value = Map<String, dynamic>.from(initialValues);
    _patchInitialValuesAfterBuild();
  }

  Map<String, dynamic> _getFormConfig() {
    //return EducationalJson.educationalSection;
    return SkillDevelopmentJson.skillDevelopmentSection;

    //   switch (data.value.sectorId) {
    //   case 'EDUCATION':
    //     return EducationalJson.educationalSection;

    //   case 'HEALTH':
    //     return HealthJson.healthSection;

    //   case 'INFRASTRUCTURE':
    //     return InfrastructureJson.infrastructureSection;

    //   default:
    //     return GeneralJson.generalSection;
    // }
  }

  void _patchInitialValuesAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryPatch());
  }

  int _patchRetries = 0;

  void _tryPatch() {
    final fields = formKey.currentState?.fields;
    if (fields == null || fields.isEmpty) {
      if (_patchRetries < 5) {
        _patchRetries++;
        WidgetsBinding.instance.addPostFrameCallback((_) => _tryPatch());
      }
      return;
    }
    _patchRetries = 0;
    patchInitialValuesToForm();
  }

  void patchInitialValuesToForm() {
    final fields = formKey.currentState?.fields;
    if (fields == null || fields.isEmpty) return;

    for (final entry in initialValue.entries) {
      final field = fields[entry.key];
      if (field == null) continue;

      final value = _valueForFormField(entry.key, entry.value);
      field.didChange(value);
    }

    dynamicFormValue.value = Map<String, dynamic>.from(
      formKey.currentState?.instantValue ?? initialValue,
    );
  }

  dynamic _valueForFormField(String fieldName, dynamic value) {
    if (_fieldType(fieldName) == 'date') {
      if (value is DateTime) return value;
      if (value == null || value.toString().trim().isEmpty) return null;
      return _parseDisplayDate(value.toString()) ??
          DateTime.tryParse(value.toString());
    }

    return value;
  }

  DateTime? _parseDisplayDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  String? _fieldType(String fieldName) {
    for (final field in dynamicFormConfig.value?.fields ?? []) {
      if (field.name == fieldName) return field.type;
    }
    return null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String? get displayedVideoPath {
    if (videoPath.value.isEmpty) return null;
    return videoPath.value;
  }

  void selectFunctionalProject(bool value) {
    isFunctionalProject.value = value;

    if (!value) {
      clearQuestionnaire();
      clearVideoSelection();
    } else {
      _patchInitialValuesAfterBuild();
    }
  }

  void updateFinishedPercentage(int value) {
    finishedPercentage.value = value;
    isFinishedPercentageAnswered.value = true;
  }

  void clearQuestionnaire() {
    timelineController.clear();
    finishedPercentage.value = 0;
    isFinishedPercentageAnswered.value = false;
    stillWorkingOnProject.value = null;
    formKey.currentState?.reset();
    dynamicFormValue.value = Map<String, dynamic>.from(initialValue);
  }

  void onDynamicFormChanged() {
    final formValue = formKey.currentState?.instantValue ?? {};
    dynamicFormValue.value = Map<String, dynamic>.from(formValue);
    _patchEnrollmentIncrease(formValue);
  }

  void _patchEnrollmentIncrease(Map<String, dynamic> formValue) {
    final current = _parseNumber(formValue['currentStudentEnrolment']);
    final before = _parseNumber(formValue['studentEnrolmentBeforeProject']);
    if (current == null || before == null) return;

    final value = current - before;
    final displayValue =
        value % 1 == 0 ? value.toInt().toString() : value.toString();
    final field = formKey.currentState?.fields['increaseInEnrolment'];
    if (field?.value?.toString() == displayValue) return;
    field?.didChange(displayValue);
    dynamicFormValue['increaseInEnrolment'] = displayValue;
  }

  num? _parseNumber(dynamic value) {
    if (value == null) return null;
    return num.tryParse(value.toString().trim());
  }

  Future<void> onCaptureVideo() async {
    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
    );

    if (insideGeofence == false) {
      //controller.showPhotoSourceDialog(index);
      PopupMixin().showErrorDialog(
        Get.context!,
        message: "You are outside the location",
      );
      return;
    }

    try {
      final compressedFile = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),
      );

      if (compressedFile == null) return;
      videoPath.value = compressedFile.path;
    } catch (e) {
      showErrorDialog(
        Get.context!,
        message: 'Unable to capture video. Please try again.',
      );
    }
  }

  void clearVideoSelection() {
    videoPath.value = '';
  }

  Future<void> submitData() async {
    if (isFunctionalProject.value == null) {
      showErrorDialog(
        Get.context!,
        message: 'Please select if the project is functional.',
      );
      return;
    }

    if (projectId.value.isEmpty) {
      showErrorDialog(Get.context!, message: 'Project id is missing.');
      return;
    }

    // if (isFunctionalProject.value == true && videoPath.value.isEmpty) {
    //   showErrorDialog(Get.context!, message: 'Please upload video.');
    //   return;
    // }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final hasInternet = await NetworkService.hasInternet();
    if (hasInternet) {
      await submitOnline();
    } else {
      showMessageDialog(
        Get.context!,
        title: "NO Internet!",
        message: "Want to save this in Local Database?",
        onPressed: () async {
          await saveOffline();
        },
      );
      isSubmitting.value = false;
    }
  }

  Future<void> submitOnline() async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Uploading...");

      // 1. Submit dynamic questionnaire form data
      if (isFunctionalProject.value == true) {
        final unitId = data.value.id ?? '';
        if (unitId.isEmpty) throw Exception("Unit code is missing.");

        final formValues = _buildSectionPostData();

        final questionnaireResp = await repo.submitQuestionnaire(
          unitId: unitId,
          formValues: formValues,
        );

        if (questionnaireResp.statusCode != '200') {
          Get.back();
          showErrorDialog(
            Get.context!,
            title: "Error",
            message: "Failed to submit questionnaire.",
          );
          return;
        }
      }

      // 2. Submit functionality status + video
      // final modelData = await repo.updateFunctionality(
      //   projectId: projectId.value,
      //   isFunctional: isFunctionalProject.value ?? false,
      //   videoPath:
      //       isFunctionalProject.value == true && videoPath.value.isNotEmpty
      //           ? videoPath.value
      //           : null,
      // );

      // if (modelData.statusCode == '200') {
      //   Get.back();

      //   showSuccessDialog(
      //     Get.context!,
      //     message: "Your data is submitted successfully",
      //     onPressed: () async {
      //       Helpers().refreshHomeIfAvailable();
      //       await _navigateToDashboard();
      //     },
      //   );
      // } else {
      //   Get.back();

      //   showErrorDialog(
      //     Get.context!,
      //     title: "Error",
      //     message: modelData.error ?? "Something went wrong.",
      //   );
      // }
    } catch (e) {
      debugPrint("submitOnline error: $e");

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      showErrorDialog(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> saveOffline() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: "Unable to identify current user");
      isSubmitting.value = false;
      return;
    }

    await repository.save(
      userId: userId,
      projectId: projectId.value,
      images: const [],
      videoPath:
          isFunctionalProject.value == true && videoPath.value.isNotEmpty
              ? videoPath.value
              : null,
      remarks: '',
      isSynced: false,
      userLat: userLat.value.toString(),
      userLng: userLng.value.toString(),
      progress: OfflineSubmissionType.functionalProject,
      projectStatus: (isFunctionalProject.value ?? false).toString(),
    );

    Helpers().refreshHomeIfAvailable();
    Get.back();
    Get.snackbar(
      'Saved Offline',
      'No internet. Data will sync automatically',
      snackPosition: SnackPosition.BOTTOM,
    );
    isSubmitting.value = false;
  }

  @override
  void onClose() {
    timelineController.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentForm() async {
    final config = _getFormConfig();
    final unitId = data.value.id ?? '';
    if (unitId.isEmpty) {
      debugPrint('Unit code is empty');
      return;
    }

    final resp = await repo.getQuestionaire(unitId: unitId);
    final questionnaireData = _questionnaireDataFromResponse(resp);

    final initialValues = _getInitialValues(
      formConfig: config,
      apiValues: questionnaireData,
    );
    _loadDynamicForm(formConfig: config, initialValues: initialValues);
  }

  Map<String, dynamic> _questionnaireDataFromResponse(
    Map<String, dynamic>? response,
  ) {
    if (response == null) return {};

    final data = response['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return Map<String, dynamic>.from(response);
  }

  Map<String, dynamic> _getInitialValues({
    required Map<String, dynamic> formConfig,
    required Map<String, dynamic> apiValues,
  }) {
    final initialValues = <String, dynamic>{};

    for (final rawField in formConfig['fields'] ?? []) {
      if (rawField is! Map) continue;

      final field = Map<String, dynamic>.from(rawField);
      final fieldName = field['name']?.toString();
      if (fieldName == null) continue;

      dynamic value;

      if (fieldName == 'geoCoordinates') {
        final lat = apiValues['latitude'];
        final lng = apiValues['longitude'];
        if (lat != null && lng != null) value = '$lat, $lng';
      } else {
        final apiKey = _fieldApiKeyMap[fieldName] ?? fieldName;
        value = apiValues[apiKey];
      }

      value = _normalizeInitialValue(field: field, value: value);
      if (value != null) initialValues[fieldName] = value;
    }

    debugPrint('DYNAMIC INITIAL VALUES: $initialValues');
    return initialValues;
  }

  dynamic _normalizeInitialValue({
    required Map<String, dynamic> field,
    required dynamic value,
  }) {
    if (value == null) return null;

    final fieldType = field['type']?.toString();
    if (fieldType == 'date' || _isDateFieldValue(value)) {
      final parsedDate =
          value is DateTime
              ? value
              : _parseDisplayDate(value.toString()) ??
                  DateTime.tryParse(value.toString());

      if (parsedDate == null) {
        return fieldType == 'date' ? null : value;
      }

      return _formatDate(parsedDate);
    }

    if (fieldType == 'radio') {
      return _normalizeRadioValue(field, value);
    }

    return value;
  }

  bool _isDateFieldValue(dynamic value) {
    if (value is DateTime) return true;
    if (value is! String) return false;

    return DateTime.tryParse(value) != null || _parseDisplayDate(value) != null;
  }

  dynamic _normalizeRadioValue(Map<String, dynamic> field, dynamic value) {
    final options = field['options'];
    if (options is! List) return value;

    for (final option in options) {
      if (option is! Map) continue;

      final optionValue = option['value'];
      if (optionValue == value) return optionValue;
      if (optionValue?.toString().toLowerCase() ==
          value.toString().toLowerCase()) {
        return optionValue;
      }
    }

    return value;
  }

  Future<void> submitQuestionnaire() async {
    try {
      // Get latest values directly from FormBuilder
      final formValues =
          formKey.currentState?.instantValue ?? <String, dynamic>{};

      if (formValues.isEmpty) {
        debugPrint('Questionnaire form values are empty');
        return;
      }

      final unitId = data.value.unitCode ?? '';

      if (unitId.isEmpty) {
        debugPrint('Unit id is empty');
        return;
      }

      debugPrint('========== QUESTIONNAIRE DATA ==========');
      debugPrint('Unit ID: $unitId');
      debugPrint('Form Values: $formValues');
      debugPrint('========================================');

      final response = await repo.submitQuestionnaire(
        unitId: unitId,
        formValues: Map<String, dynamic>.from(formValues),
      );

      debugPrint(
        'Questionnaire submit response: '
        '${response.statusCode}',
      );

      if (response.statusCode == "200") {
        Get.snackbar(
          'Success',
          response.statusMessage ?? 'Questionnaire submitted successfully',
        );
      } else {
        Get.snackbar(
          'Error',
          response.statusMessage ?? 'Failed to submit questionnaire',
        );
      }
    } catch (e) {
      debugPrint('submitQuestionnaire controller error: $e');

      Get.snackbar(
        'Error',
        'Something went wrong while submitting questionnaire',
      );
    }
  }

  static const Map<String, String> _fieldApiKeyMap = {
    'blockTown': 'block/town',
    'pmjvkProjectId': 'projectUniqueId',
    'subSectorProjectType': 'projectType',
  };

  Map<String, dynamic> _buildSectionPostData() {
    final data = <String, dynamic>{};
    final fields = dynamicFormConfig.value?.fields ?? [];

    for (final field in fields) {
      if (field.type == 'labelText') continue;

      final rawValue = formKey.currentState?.fields[field.name]?.value;

      data[field.name] =
          rawValue is DateTime ? _formatDate(rawValue) : rawValue;
    }

    return data;
  }
}
