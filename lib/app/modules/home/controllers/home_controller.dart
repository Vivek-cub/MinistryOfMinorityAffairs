import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
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
  //final ProjectDao projectDao;

  HomeController(this.repo,this.authService,this.submissionRepo,this.projectRepo);
  // User info
  final userName = 'Ramesh'.obs;
  
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
  final workList = <ProjectModel>[].obs;
  final isLoading = false.obs;
  Rx<HomeData> data = HomeData().obs;
  RxBool hasInternet=true.obs;

  @override
  void onInit() {
    super.onInit();
   //checkInternet();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getDashboardCount();
    });
    _loadStaticData();
    _syncPendingSubmissions();
    
  }

  Future<void> checkInternet()async{
     hasInternet.value = await NetworkService.hasInternet();
    if(hasInternet.value==true){
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getDashboardCount();
    });
    _loadStaticData();
    _syncPendingSubmissions();
    }
  }

  void _loadStaticData() {
    // Static data for demonstration
    workList.value = [
      ProjectModel(
        id: 'UPDW20090274',
        title: 'Installation of hand pumps at various locations',
        location: 'SHAHJAHANPUR',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 90)),
        isGeotagged: true,
        department: 'Govt. Boys School',
      ),
      ProjectModel(
        id: 'UPDW20090275',
        title: 'Construction of community hall',
        location: 'AMETHI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        isGeotagged: false,
        department: 'Community Center',
      ),
      ProjectModel(
        id: 'UPDW20090276',
        title: 'Electrification of minority area villages',
        location: 'LUCKNOW',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 15)),
        isGeotagged: true,
        department: 'Power Department',
      ),
      ProjectModel(
        id: 'UPDW20090277',
        title: 'Construction of toilets in schools',
        location: 'BAREILLY',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isGeotagged: true,
        department: 'Education Department',
      ),
      ProjectModel(
        id: 'UPDW20090278',
        title: 'Road construction and maintenance',
        location: 'MORADABAD',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        isGeotagged: false,
        department: 'PWD',
      ),
      ProjectModel(
        id: 'UPDW20090279',
        title: 'Drinking water supply scheme',
        location: 'ALIGARH',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 60)),
        isGeotagged: true,
        department: 'Jal Nigam',
      ),
      ProjectModel(
        id: 'UPDW20090280',
        title: 'Skill development center establishment',
        location: 'RAMPUR',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        isGeotagged: false,
        department: 'Skill Development',
      ),
      ProjectModel(
        id: 'UPDW20090281',
        title: 'Anganwadi center renovation',
        location: 'PILIBHIT',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        isGeotagged: true,
        department: 'Women & Child',
      ),
    ];
  }

  void onUpdateProgressTap(ProjectModel project) {
    // Navigate to project detail/update page
    Get.snackbar(
      'Update Progress',
      'Navigating to update progress for ${project.id}',
      snackPosition: SnackPosition.BOTTOM,
    );
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


  void getDashboardCount() async{
    
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

  //Upload one by one
  for (final item in pendingList) {
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
        await submissionRepo.markAsSynced(item.submission.id);
        debugPrint('Synced submission ${item.submission.id}');
        Get.back();
      }
    } catch (e) {
      //Fail silently, retry later
      debugPrint('Sync failed for ${item.submission.id}: $e');
    }
  }
}



}
