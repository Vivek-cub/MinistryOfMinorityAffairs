import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';

/// Home screen controller
/// Manages home screen state and business logic
class HomeController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();
    _loadStaticData();
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
    // Navigate to all projects list
    Get.snackbar(
      'View All',
      'Navigating to all projects list',
      snackPosition: SnackPosition.BOTTOM,
    );
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
      onConfirm: () {
        Get.back();
        // Perform logout
        Get.snackbar(
          'Logged Out',
          'You have been logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
