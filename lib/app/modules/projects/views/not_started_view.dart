import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import '../controllers/not_started_controller.dart';

/// Not Started view
/// Displays all projects with "not_started" status
class NotStartedView extends GetView<NotStartedController> {
  const NotStartedView({super.key});

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
                title: controller.screenTitle,
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: ImageAssets.emblemImage,
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
                  return Container();

                  // return RefreshIndicator(
                  //   onRefresh: controller.refreshProjects,
                  //   child: ListView.builder(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16),
                  //     itemCount: controller.filteredProjects.length,
                  //     itemBuilder: (context, index) {
                  //       final project = controller.filteredProjects[index];
                  //       return WorkProgressCard(
                  //         project: project,
                  //         onUpdateProgress: () =>
                  //             controller.onUpdateProgress(project),
                  //       );
                  //     },
                  //   ),
                  // );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
