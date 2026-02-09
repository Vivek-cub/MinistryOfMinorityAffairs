
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/domain/repo/project_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class ProjectsListController extends GetxController with SnackBarMixin,PopupMixin{

  final ProjectListRepo repo;
  final AuthService authService;

  ProjectsListController(this.repo,this.authService);

   RxString statusFilter="".obs;

  final searchQuery = ''.obs;
  
  // Selected filters
  final selectedSector = Rx<String?>('');
  final selectedYear = Rx<String?>('');
  
  // Dropdown states
  final isSectorDropdownOpen = false.obs;
  final isYearDropdownOpen = false.obs;
  
  // Loading state
  final isLoading = false.obs;
  
  // Screen title based on status
  String get screenTitle {
    switch (statusFilter.value) {
      case 'in_progress':
        return 'Work In Progress';
      case 'completed':
        return 'Completed Tasks';
      case 'not_started':
        return 'Not Started';
      default:
        return 'Projects';
    }
  }

  RxString status="".obs;
  RxBool geoStatus=false.obs;

  RxString paramName="".obs;

  final RxList<UserProject> projects = <UserProject>[].obs;


  @override
void onInit() {
  super.onInit();

  final args = Get.arguments;

  if (args is Map<String, dynamic>) {
    status.value = args['status']?.toString() ?? '';
    paramName.value = args['paramName']?.toString() ?? '';
    geoStatus.value = args['geoStatus'] ?? false;
    statusFilter.value = args['statusFilter']?.toString() ?? '';
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!isClosed) {
      if(paramName.value=="geoTagged"){
        loadProjectsbyGeoTagged();
      }else if(paramName.value=="noInternet"){
          
      }
      else{
        loadProjects();
      }
      
    }
  });
}

  void loadProjects() async{
    try {
      isLoading(true);
      final modelData = await repo.getProjectList(status: status.value,paramName: paramName.value);
      isLoading(false);
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects !=null) {
          projects.value = modelData!.data?.projects??[];
        }
      } else {
        
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      
      
     
    } finally {
      isLoading(false);
    }
  }

  void loadProjectsbyGeoTagged() async{
    try {
      isLoading(true);
      final modelData = await repo.getProjectListByGeoTagged(status: geoStatus.value,paramName: paramName.value);
      
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects !=null) {
          projects.value = modelData!.data?.projects??[];
        }
      } else {
        
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw e;
      
     
    } finally {
      isLoading(false);
    }
  }

  void loadLocalDb(){

  }

  

  void onSearchChanged(String query) {
    searchQuery.value = query;
   // _applyFilters();
  }

  void onSectorSelected(String? sector) {
    selectedSector.value = sector;
    isSectorDropdownOpen.value = false;
   // _applyFilters();
  }

  void onYearSelected(String? year) {
    selectedYear.value = year;
    isYearDropdownOpen.value = false;
   // _applyFilters();
  }

  void toggleSectorDropdown() {
    isSectorDropdownOpen.value = !isSectorDropdownOpen.value;
    if (isSectorDropdownOpen.value) {
      isYearDropdownOpen.value = false;
    }
  }

  void toggleYearDropdown() {
    isYearDropdownOpen.value = !isYearDropdownOpen.value;
    if (isYearDropdownOpen.value) {
      isSectorDropdownOpen.value = false;
    }
  }

  // void _applyFilters() {
  //   var filtered = projects.where((project) {
  //     // Filter by status
  //     if (project.status != statusFilter) {
  //       return false;
  //     }
      
  //     // Filter by search query
  //     if (searchQuery.value.isNotEmpty) {
  //       final query = searchQuery.value.toLowerCase();
  //       if (!project..toLowerCase().contains(query) &&
  //           !project.location.toLowerCase().contains(query) &&
  //           !project.id.toLowerCase().contains(query)) {
  //         return false;
  //       }
  //     }
      
  //     // Filter by sector (if implemented)
  //     // Filter by year (if implemented)
      
  //     return true;
  //   }).toList();
    
  //   filteredProjects.value = filtered;
  // }

  void onUpdateProgress(ProjectDetails project) {
    // Get.snackbar(
    //   'Update Progress',
    //   'Updating progress for ${project.id}',
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    Get.toNamed(AppRoutes.workDetail,arguments: {
      "project":project
    });
    // Navigate to update progress screen
  }

  List<String> get sectors => [
    'Animal Husbandry',
    'DWS',
    'Education',
    'Health',
    'Housing',
    'Other Community Infrastructure',
    'Others',
    'Renewable Energy',
    'Sanitation',
    'Skill',
    'SNA release',
    'Sports',
    'Tourism',
    'WCD',
  ];

  List<String> get years => [
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
  ];
}