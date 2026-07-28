import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/financial_year_name.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/domain/repo/project_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class ProjectListController extends GetxController
    with SnackBarMixin, PopupMixin {
  final ProjectListRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;

  ProjectListController(this.repo, this.authService, this.dbRepo);

  RxString statusFilter = "".obs;

  final searchQuery = ''.obs;

  // Selected filters
  final selectedSector = Rx<String?>('');
  final Rx<FinancialYearName?> selectedYear = Rx<FinancialYearName?>(null);

  // Dropdown states
  final isSectorDropdownOpen = false.obs;
  final isYearDropdownOpen = false.obs;

  // Loading state
  RxBool isLoading = true.obs;
  RxBool isDataLoaded = false.obs;

  RxString status = "".obs;
  RxBool geoStatus = false.obs;
  RxBool isShowingCalendar = false.obs;

  RxString paramName = "".obs;

  final RxList<UserProject> projects = <UserProject>[].obs;
  final RxList<UserProject> pendingProjects = <UserProject>[].obs;
  final RxList<UserProject> allProjects = <UserProject>[].obs;
  final RxList<Category> category = <Category>[].obs;
  final RxList<FinancialYearName> yearName = <FinancialYearName>[].obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  RxBool showFunctionalButton = false.obs;

  RxBool isFilterSelected = false.obs;
  RxString userId = "".obs;
  final searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      status.value = args['status']?.toString() ?? '';
      paramName.value = args['paramName']?.toString() ?? '';
      geoStatus.value = args['geoStatus'] ?? false;
      isShowingCalendar.value = args['showCalendar'] ?? false;
      statusFilter.value = args['statusFilter']?.toString() ?? '';
      userId.value = args['userId']?.toString() ?? '';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isClosed) {
        debugPrint(paramName.value);
        checkParamToLoadProject();
      }
    });

    getAllSector();
    getAllFinancialYears();
  }

  void checkParamToLoadProject() {
    if (paramName.value == "geoTagged") {
      loadProjectsbyGeoTagged();
    } else if (paramName.value == "noInternet") {
      loadOfflineProjects();
    } else if (paramName.value == "pending") {
      loadPendingProjects();
    } else if (paramName.value == "officer") {
      getOfficerDetails();
    } else {
      loadProjects();
    }
  }

  void loadProjects() async {
    try {
      isLoading(true);
      isDataLoaded(false);

      String sectorId = "";
      if (selectedCategory.value != null) {
        sectorId = selectedCategory.value?.id ?? "";
      }
      String yearId = "";
      if (selectedYear.value != null) {
        yearId = selectedYear.value?.id ?? "";
      }
      final modelData = await repo.getProjectList(
        status: status.value,
        paramName: paramName.value,
        sectorId: sectorId,
        year: yearId,
        startDate: "",
        endDate: "",
      );
      // isLoading(false);
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          final fetchedProjects = modelData?.data?.projects ?? [];

          projects.assignAll(fetchedProjects);
          allProjects.assignAll(fetchedProjects);
          // projects.value = modelData!.data?.projects ?? [];
          // allProjects.value = List.from(modelData.data?.projects ?? []);
        }
      }
      isDataLoaded(true);
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  void loadProjectsbyGeoTagged() async {
    try {
      isLoading(true);
      isDataLoaded(false);
      String sectorId = "";
      if (selectedCategory.value != null) {
        sectorId = selectedCategory.value?.id ?? "";
      }
      String yearId = "";
      if (selectedYear.value != null) {
        yearId = selectedYear.value?.id ?? "";
      }
      final modelData = await repo.getProjectListByGeoTagged(
        status: geoStatus.value,
        paramName: paramName.value,
        sectorId: sectorId,
        year: yearId,
        startDate: "",
        endDate: "",
      );

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          final fetchedProjects = modelData?.data?.projects ?? [];

          projects.assignAll(fetchedProjects);
          allProjects.assignAll(fetchedProjects);
          // projects.value = modelData!.data?.projects ?? [];
          // allProjects.value = List.from(modelData.data?.projects ?? []);
        }
      }
      isDataLoaded(true);
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadOfflineProjects() async {
    isLoading(true);
    isDataLoaded(false);

    try {
      final userId = await authService.getUserToken();
      if (userId == null || userId.isEmpty) {
        projects.clear();
        return;
      }
      final localProjects = await dbRepo.getLocalProjects(
        userId,
      ); // List<ProjectDetails>

      projects.value =
          localProjects
              .where((p) => p.id != null && p.id!.isNotEmpty)
              .fold<Map<String, UserProject>>({}, (map, p) {
                map[p.id!] = UserProject(
                  projectId: p.id,
                  status: p.status,
                  createdAt: p.createdAt,
                  unitDetails: p,
                );
                return map;
              })
              .values
              .toList();

      allProjects.value = List.from(projects);
      isDataLoaded(true);
    } finally {
      isLoading(false);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.length < 4) {
      projects.value = List.from(allProjects);
      return;
    }
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.toLowerCase();

    final filtered =
        allProjects.where((project) {
          final unitDetails = project.displayUnitDetails;
          final name =
              (unitDetails.projectName ??
                      unitDetails.unitProject?.projectName ??
                      '')
                  .toLowerCase();
          final address =
              (unitDetails.address ??
                      unitDetails.unitProject?.districtName ??
                      unitDetails.districtName ??
                      '')
                  .toLowerCase();
          final id = unitDetails.unitCode?.toLowerCase() ?? '';
          debugPrint("check $id");

          return name.contains(query) ||
              address.contains(query) ||
              id.contains(query);
        }).toList();

    projects.value = filtered;
  }

  void onUpdateProgress({
    required UnitDetails project,
    required String projectStatus,
    required String id,
    required UserProject? userProject,
    required int noOfUnitsFunctional,
  }) {
    if (projectStatus == "Completed" &&
        (noOfUnitsFunctional == -1 || noOfUnitsFunctional == 0)) {
      Get.toNamed(
        AppRoutes.projectFunctional,
        arguments: {"project": project, "status": projectStatus, "id": id},
      );
      return;
    }
    if (isShowingCalendar.value == true) {
      Get.toNamed(
        AppRoutes.calendarProject,
        arguments: {"project": project, "status": projectStatus},
      );
    } else {
      Get.toNamed(
        AppRoutes.uploadProjectDetails,
        arguments: {
          "project": project,
          "status": projectStatus,
          "id": id,
          "userProject": userProject,
        },
      );
    }
  }

  Future<void> getAllSector() async {
    try {
      isLoading(true);
      final modelData = await repo.getAllSector();

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null) {
          category.value = modelData!.data ?? [];
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getAllFinancialYears() async {
    try {
      isLoading(true);
      final modelData = await repo.getAllFinancialYears();

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null) {
          yearName.value = modelData!.data ?? [];
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  void loadPendingProjects() async {
    try {
      isLoading(true);
      isDataLoaded(false);

      final modelData = await repo.getPendingProjectList();

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          projects.value = modelData!.data?.projects ?? [];
          allProjects.value = List.from(modelData.data?.projects ?? []);
        }
      }
      isDataLoaded(true);
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  void getOfficerDetails() async {
    try {
      isLoading(true);
      isDataLoaded(false);
      final modelData = await repo.getOfficerDetails(userId: userId.value);
      // isLoading(false);
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          projects.value = modelData!.data?.projects ?? [];
          allProjects.value = List.from(modelData.data?.projects ?? []);
        }
      }
      isDataLoaded(true);
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
}

// List<String> get years => [
  //   '2013',
  //   '2014',
  //   '2015',
  //   '2016',
  //   '2017',
  //   '2018',
  //   '2019',
  //   '2020',
  //   '2021',
  //   '2022',
  //   '2023',
  //   '2024',
  //   '2025',
  // ];


  // if (status.value == "Proposal") {
    //   Get.toNamed(
    //     AppRoutes.uploadProjectDetails,
    //     arguments: {"project": project, "status": projectStatus},
    //   );
    // } else {
    //   Get.toNamed(
    //     AppRoutes.workDetail,
    //     arguments: {"project": project, "status": projectStatus},
    //   );
    // }
