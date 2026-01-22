import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';

/// Projects list controller
/// Manages state and business logic for projects list screen
/// Supports filtering by status (in_progress, completed, not_started)
class ProjectsListController extends GetxController {
  // Status filter - passed from route arguments
  final String statusFilter;
  
  // All projects
  final allProjects = <ProjectModel>[].obs;
  
  // Filtered projects
  final filteredProjects = <ProjectModel>[].obs;
  
  // Search query
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
    switch (statusFilter) {
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

  ProjectsListController({required this.statusFilter});

  @override
  void onInit() {
    super.onInit();
    _loadProjects();
  }

  void _loadProjects() {
    isLoading.value = true;
    
    // Load static data (replace with API call later)
    allProjects.value = _getStaticProjects();
    
    // Filter by status
    _applyFilters();
    
    isLoading.value = false;
  }

  List<ProjectModel> _getStaticProjects() {
    // Extended static data for demonstration
    return [
      // In Progress Projects
      ProjectModel(
        id: 'UPDW20080145',
        title: 'Extra deep mark-II hand pumps',
        location: 'LAKHIMPUR KHERI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW20120052',
        title: 'Water supply scheme (10 km pipe line 2 Overhead tank 1600 KL capacity 7 tube wells)',
        location: 'HAZRATPUR, BADAUN',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW202420853',
        title: 'Road Repair Work (2 Km resurfacing near the main market area)',
        location: 'KASBA AREA, BARABANKI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 24)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120053',
        title: 'Water supply scheme (7 km of pipe line and 1 Overhead tank with 1100 KL capacity 7 tube wells)',
        location: 'LAKHIMPUR KHERI',
        status: 'in_progress',
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
        isGeotagged: true,
      ),
      
      // Not Started Projects
      ProjectModel(
        id: 'UPDW20080145',
        title: 'Laying 5 km of underground sewage lines (Phase II)',
        location: 'LAKHIMPUR KHERI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120052',
        title: 'Stormwater Drainage Channel Construction- Building new drainage pathways to reduce flooding',
        location: 'GOLA BLOCK, LAKHIMPUR KHERI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 45)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120053',
        title: 'Extra Deep Mark-II Hand Pump Installation- Ensuring deeper groundwater access in rural areas',
        location: 'KUNDA NAGAR, PRATAPGARH',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 60)),
        isGeotagged: false,
      ),
      ProjectModel(
        id: 'UPDW20120054',
        title: 'Overhead Water Tank Construction (1500 KL) Elevated storage tank under construction',
        location: 'BARABANKI',
        status: 'not_started',
        updatedAt: DateTime.now().subtract(const Duration(days: 20)),
        isGeotagged: false,
      ),
      
      // Completed Projects
      ProjectModel(
        id: 'UPDW20080145',
        title: 'Extra deep mark-II hand pumps',
        location: 'LAKHIMPUR KHERI',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 12)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW20120052',
        title: 'Water supply scheme (10 km pipe line 2 Overhead tank 1600 KL capacity 7 tube wells)',
        location: 'BARABANKI',
        status: 'completed',
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
        isGeotagged: true,
      ),
      ProjectModel(
        id: 'UPDW202420853',
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
    var filtered = allProjects.where((project) {
      // Filter by status
      if (project.status != statusFilter) {
        return false;
      }
      
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
    Get.snackbar(
      'Update Progress',
      'Updating progress for ${project.id}',
      snackPosition: SnackPosition.BOTTOM,
    );
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
