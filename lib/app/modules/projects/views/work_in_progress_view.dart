import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import '../controllers/work_in_progress_controller.dart';

/// Work In Progress view
/// Displays all projects with "in_progress" status
class WorkInProgressView extends GetView<WorkInProgressController> {
  const WorkInProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primary,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    // Header
                    WorkProgressHeader(
                      userName: 'User Name',
                      title: controller.screenTitle,
                      subtitle: 'Track Progress of works in real-time',
                      avatarAssetPath: 'assets/images/emblem.png',
                    ),
                    // Search and Filters Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: SearchBarWidget(
                              hintText: 'Search',
                              onChanged: controller.onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sector Wise Dropdown
                          SizedBox(
                            width: 120,
                            child: FilterDropdown<String>(
                              label: 'Sector Wise',
                              selectedValue: controller.selectedSector.value,
                              items: controller.sectors,
                              isOpen: controller.isSectorDropdownOpen.value,
                              onTap: controller.toggleSectorDropdown,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Year Wise Dropdown
                          SizedBox(
                            width: 120,
                            child: FilterDropdown<String>(
                              label: 'Year Wise',
                              selectedValue: controller.selectedYear.value,
                              items: controller.years,
                              isOpen: controller.isYearDropdownOpen.value,
                              onTap: controller.toggleYearDropdown,
                            ),
                          ),
                        ],
                      ),
                    ),

                    
                    // Projects List
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.errorMessage.value != null &&
                            controller.errorMessage.value!.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.errorMessage.value ?? 'Error',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: controller.refreshProjects,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (controller.filteredProjects.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: AppColors.textHint,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No projects found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: controller.refreshProjects,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.filteredProjects.length,
                            itemBuilder: (context, index) {
                              final project =
                                  controller.filteredProjects[index];
                              return WorkProgressCard(
                                project: project,
                                onUpdateProgress:
                                    () => controller.onUpdateProgress(project),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                // Sector Wise Dropdown Menu
                if (controller.isSectorDropdownOpen.value)
                  Positioned(
                    top: 220, // Header height + padding + dropdown height
                    left: 120, // 16 (padding) + 120 (search) + 12 (spacing)
                    child: FilterDropdownMenu<String>(
                      width: 200,
                      items: controller.sectors,
                      onItemSelected: controller.onSectorSelected,
                    ),
                  ),
                // Year Wise Dropdown Menu
                if (controller.isYearDropdownOpen.value)
                  Positioned(
                    top: 220, // Header height + padding + dropdown height
                    left:
                        250, // 16 (padding) + 120 (search) + 12 (spacing) + 100 (sector) + 12 (spacing)
                    child: FilterDropdownMenu<String>(
                      width: 120,
                      items: controller.years,
                      onItemSelected: controller.onYearSelected,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
