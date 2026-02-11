import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

/// Projects list view
/// Reusable screen for displaying projects filtered by status
/// Supports: in_progress, completed, not_started
class ProjectsListView extends GetView<ProjectsListController> {
  const ProjectsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.governmentGold,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              // Header
              WorkProgressHeader(
                //title: controller.screenTitle,
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: 'assets/images/emblem.png',
              ),
              // Search and Filters Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Expanded(
                          child: SearchBarWidget(
                            hintText: 'Search',
                            onChanged: controller.onSearchChanged,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Sector Wise Dropdown
                        Obx(
                          () => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FilterDropdown<String>(
                                label: 'Sector Wise',
                                selectedValue: controller.selectedSector.value,
                                items: controller.sectors,
                                itemBuilder: (item) => item,
                                isOpen: controller.isSectorDropdownOpen.value,
                                onTap: controller.toggleSectorDropdown,
                              ),
                              if (controller.isSectorDropdownOpen.value)
                                Positioned(
                                  top: 56,
                                  left: 0,
                                  right: 0,
                                  child: FilterDropdownMenu<String>(
                                    width: 200,
                                    items: controller.sectors,
                                    itemBuilder: (item) => item,
                                    onItemSelected: controller.onSectorSelected,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Year Wise Dropdown
                        Obx(
                          () => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FilterDropdown<String>(
                                label: 'Year Wise',
                                selectedValue: controller.selectedYear.value,
                                items: controller.years,
                                itemBuilder: (item) => item,
                                isOpen: controller.isYearDropdownOpen.value,
                                onTap: controller.toggleYearDropdown,
                              ),
                              if (controller.isYearDropdownOpen.value)
                                Positioned(
                                  top: 56,
                                  left: 0,
                                  right: 0,
                                  child: FilterDropdownMenu<String>(
                                    width: 200,
                                    items: controller.years,
                                    itemBuilder: (item) => item,
                                    onItemSelected: controller.onYearSelected,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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

                  if (controller.projects.isEmpty) {
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
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.projects.length,
                    itemBuilder: (context, index) {
                      final project = controller.projects[index];
                      return WorkProgressCard(
                        project: project,
                        onUpdateProgress: (){
                           controller.onUpdateProgress(project.project??ProjectDetails());
                        }
                           
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
