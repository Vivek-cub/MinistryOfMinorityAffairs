import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';

/// Base controller for all project list screens
/// Contains shared logic that can be extended by specific controllers
abstract class BaseProjectsController extends GetxController {
  // Status filter - must be set by child classes
  String get statusFilter;

  // All projects
  final allProjects = <ProjectModel>[].obs;

  // Filtered projects
  final filteredProjects = <ProjectModel>[].obs;

  // Search query
  final searchQuery = ''.obs;

  // Selected filters
  final selectedSector = Rx<String?>(null);
  final selectedYear = Rx<String?>(null);

  // Dropdown states
  final isSectorDropdownOpen = false.obs;
  final isYearDropdownOpen = false.obs;

  // Loading state
  final isLoading = false.obs;

  // Error state
  final errorMessage = ''.obs;

  // Screen title - to be overridden by child classes
  String get screenTitle => 'Projects';

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  /// Load projects - to be implemented by child classes
  /// Can call API or load from local storage
  Future<void> loadProjects() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // For now, load static data
      // In future, replace with API call: await fetchProjectsFromAPI();
      final projects = await loadStaticData();
      allProjects.value = projects;
      _applyFilters();
    } catch (e) {
      errorMessage.value = 'Failed to load projects: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch projects from API - to be implemented by child classes
  /// Each screen can have its own API endpoint
  Future<List<ProjectModel>> fetchProjectsFromAPI() async {
    // Override in child classes with specific API endpoints
    // Example:
    // final response = await apiService.get('/projects?status=$statusFilter');
    // return response.data.map((json) => ProjectModel.fromJson(json)).toList();
    return [];
  }

  /// Load static data for demonstration
  Future<List<ProjectModel>> loadStaticData() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final allProjects = getStaticProjects();
    return allProjects.where((project) {
      return project.status == statusFilter;
    }).toList();
  }

  /// Get all static projects
  List<ProjectModel> getStaticProjects() {
    return [
      // In Progress Projects
      ProjectModel(
        id: 'UPED20100152',
        title:
            '9 additional classrooms for three higher secondary schools located in Sarva nagar Dhourana and Lakhimpur',
        location: 'LAKHIMPUR KHERI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        isGeotagged: true,
        state: 'Uttar Pradesh',
        district: 'Lakhimpur Kheri',
        block: 'Pasgawan',
        workType: 'Education',
        approvalYear: '2025',
      ),
      ProjectModel(
        id: 'UPDW20080145',
        title: 'Extra deep mark-II hand pumps',
        location: 'LAKHIMPUR KHERI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        isGeotagged: true,
        state: 'Uttar Pradesh',
        district: 'Lakhimpur Kheri',
        block: 'Pasgawan',
        workType: 'DWS',
        approvalYear: '2024',
      ),
      ProjectModel(
        id: 'UPDW20120052',
        title:
            'Water supply scheme (10 km pipe line 2 Overhead tank 1600 KL capacity 7 tube wells)',
        location: 'HAZRATPUR, BADAUN',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        isGeotagged: true,
        state: 'Uttar Pradesh',
        district: 'Badaun',
        block: 'Hazratpur',
        workType: 'DWS',
        approvalYear: '2023',
      ),
      ProjectModel(
        id: 'UPDW202420853',
        title: 'Road Repair Work (2 Km resurfacing near the main market area)',
        location: 'KASBA AREA, BARABANKI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 24)),
        isGeotagged: false,
        state: 'Uttar Pradesh',
        district: 'Barabanki',
        block: 'Kasba',
        workType: 'Other Community Infrastructure',
        approvalYear: '2024',
      ),
      ProjectModel(
        id: 'UPDW20120053',
        title:
            'Water supply scheme (7 km of pipe line and 1 Overhead tank with 1100 KL capacity 7 tube wells)',
        location: 'LAKHIMPUR KHERI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
        isGeotagged: true,
        state: 'Uttar Pradesh',
        district: 'Lakhimpur Kheri',
        block: 'Pasgawan',
        workType: 'DWS',
        approvalYear: '2023',
      ),

      // Not Started Projects
      ProjectModel(
        id: 'UPDW20080146',
        title: 'Laying 5 km of underground sewage lines (Phase II)',
        location: 'LAKHIMPUR KHERI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120054',
        title:
            'Stormwater Drainage Channel Construction- Building new drainage pathways to reduce flooding',
        location: 'GOLA BLOCK, LAKHIMPUR KHERI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120055',
        title:
            'Extra Deep Mark-II Hand Pump Installation- Ensuring deeper groundwater access in rural areas',
        location: 'KUNDA NAGAR, PRATAPGARH',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 60)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120056',
        title:
            'Overhead Water Tank Construction (1500 KL) Elevated storage tank under construction',
        location: 'BARABANKI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        isGeotagged: false,
      ),

      // Completed Projects
      ProjectModel(
        id: 'UPDW20080147',
        title: 'Extra deep mark-II hand pumps',
        location: 'LAKHIMPUR KHERI',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW20120057',
        title:
            'Water supply scheme (10 km pipe line 2 Overhead tank 1600 KL capacity 7 tube wells)',
        location: 'BARABANKI',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW202420854',
        title: 'Road Repair Work (2 Km resurfacing near the main market area)',
        location: 'BARABANKI',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 24)),
        isGeotagged: true,
      ),
    ];
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void onSectorSelected(String? sector) {
    selectedSector.value = sector;
    isSectorDropdownOpen.value = false;
    _applyFilters();
  }

  void onYearSelected(String? year) {
    selectedYear.value = year;
    isYearDropdownOpen.value = false;
    _applyFilters();
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

  void _applyFilters() {
    var filtered =
        allProjects.where((project) {
          // Filter by search query
          if (searchQuery.value.isNotEmpty) {
            final query = searchQuery.value.toLowerCase();
            if (!project.title.toLowerCase().contains(query) &&
                !project.location.toLowerCase().contains(query) &&
                !project.id.toLowerCase().contains(query)) {
              return false;
            }
          }

          // Filter by sector (if implemented)
          // Filter by year (if implemented)

          return true;
        }).toList();

    filteredProjects.value = filtered;
  }

  void onUpdateProgress(ProjectModel project) {
    Get.toNamed(AppRoutes.workDetail, arguments: project);
  }

  /// Refresh projects list
  Future<void> refreshProjects() async {
    await loadProjects();
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
