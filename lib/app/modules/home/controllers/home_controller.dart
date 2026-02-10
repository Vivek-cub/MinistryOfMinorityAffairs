import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';

/// Home screen controller
/// Manages home screen state and business logic
class HomeController extends GetxController with SnackBarMixin{
  final HomeRepo repo;
  final AuthService authService;
  final SubmissionRepository submissionRepo;
  final ProjectDetailRepo projectRepo;
  

  HomeController(this.repo,this.authService,this.submissionRepo,this.projectRepo);
  // User info
  final userName = ''.obs;
  
  // Dashboard statistics
  final dashboardStats = Rx<DashboardStats>(
    DashboardStats(
      totalAssigned: 1367,
      inProgress: 507,
      notStarted: 623,
      completed: 237,
      geotagged: 600,
      nonGeotagged: 767,
    ),
  );

  // Work list
  final isLoading = false.obs;
  Rx<HomeData> data = HomeData().obs;
  RxBool hasInternet=true.obs;
  final RxList<UserProject> projects = <UserProject>[].obs;

  @override
  void onInit() {
    super.onInit();
   checkInternet();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // getDashboardCount();
    // });
    // _loadStaticData();
    // _syncPendingSubmissions();
    
  }

  Future<void> checkInternet()async{
     hasInternet.value = await NetworkService.hasInternet();
    if(hasInternet.value==true){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await getDashboardCount();
    await loadProjects();
    });
    
    }
  }

  

  Future<void> loadProjects() async{
    try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Fetching..."
      );
      final modelData = await repo.getAssignedProjects();
      
      if (modelData?.statusCode == "200") {
        Get.back();
        if (modelData?.data != null && modelData?.data?.projects !=null) {
          projects.value = modelData!.data?.projects??[];
        }
      } else {
        Get.back();
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      
      Get.back();
     
    } finally {
      isLoading(false);
    }
    //_syncPendingSubmissions();
  }

  void onUpdateProgressTap(ProjectDetails project) {
    // Navigate to project detail/update page
    Get.toNamed(AppRoutes.workDetail,arguments: {
      "project":project
    });
  }

  void onViewAllTap() {
    // Navigate to work in progress screen
    Get.toNamed(AppRoutes.workInProgress);
  }

  void onChangePinTap() {
    Get.snackbar(
      'Change PIN',
      'Navigating to change PIN screen',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onSettingsTap() {
    Get.snackbar(
      'Settings',
      'Navigating to settings screen',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onLogoutTap() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async{
        Get.back();
        // Perform logout
        await authService.onLogout();
        Get.snackbar(
          'Logged Out',
          'You have been logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(AppRoutes.splash);
      },
    );
  }


  Future<void> getDashboardCount() async{
    
    try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Fetching..."
      );
      final modelData = await repo.getHomeData();
      
      if (modelData?.statusCode == "200") {
        Get.back();
        if (modelData?.data != null) {
          data.value = modelData!.data!;
          userName(data.value.user?.name??"");
        }
      } else {
        Get.back();
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      Get.back();
     
    } finally {
      
    }
    
  }


Future<void> _syncPendingSubmissions() async {
  //Check internet
  final hasInternet = await NetworkService.hasInternet();
  if (!hasInternet) {
    debugPrint('No internet, skipping sync');
    return;
  }

  //Fetch pending data
  final pendingList = await submissionRepo.getPending();

  if (pendingList.isEmpty) {
    debugPrint('No pending submissions');
    return;
  }

  debugPrint('Syncing ${pendingList.length} pending submissions');
    final uniquePendingList = _uniqueByProjectId(pendingList);

debugPrint(
    'Syncing ${uniquePendingList.length} '
    'unique projects (from ${pendingList.length})',
  );

  //Upload one by one
  for (final item in uniquePendingList) {
    try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Uploading..."
      );
      final response = await projectRepo.uploadMilestoneFiles(
        projectId: item.submission.projectId,
        milestoneId: item.submission.milestoneId,
        imagePaths: item.images.map((e) => e.filePath).toList(),
        audioPath: item.audio?.filePath,
        videoPath: item.video?.filePath,
      );

      //Mark as synced on success
      if (response.statusCode == '200') {
        await submissionRepo.markAsSynced(item.submission.projectId);
        debugPrint('Synced submission ${item.submission.id}');
        Get.back();
      }
    } catch (e) {
      //Fail silently, retry later
      debugPrint('Sync failed for ${item.submission.id}: $e');
    }
  }
}

List<PendingSubmission> _uniqueByProjectId(
    List<PendingSubmission> list) {

  final seen = <String>{};
  final result = <PendingSubmission>[];

  for (final item in list) {
    final projectId = item.submission.projectId;
    if (seen.add(projectId)) {
      result.add(item); // first occurrence kept
    }
  }

  return result;
}




}
