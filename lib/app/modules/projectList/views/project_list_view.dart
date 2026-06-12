import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/financial_year_name.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/widget/app_dropdown.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class ProjectListView extends GetView<ProjectListController> {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    WorkProgressHeader(
                      //title: controller.screenTitle,
                      title: "Project List",
                      subtitle: 'Track Progress of works in real-time',
                      avatarAssetPath: ImageAssets.emblemImage,
                      backIcon: Icons.arrow_back,
                      widget: Row(
                        children: [
                          Expanded(
                            child: Container(
                              // width: MediaQuery.of(context).size.width * 0.75,
                              margin: EdgeInsets.only(
                                top: AppDimensions.md,
                                left: AppDimensions.sm,
                                right: AppDimensions.sm,
                              ),

                              child: SearchBarWidget(
                                hintText: 'Search',
                                onChanged: controller.onSearchChanged,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.isFilterSelected.value =
                                  !controller.isFilterSelected.value;
                              if (controller.isFilterSelected.value == true) {
                              } else {
                                controller.selectedCategory.value = null;
                                controller.selectedYear.value = null;
                                controller.searchQuery.value = "";
                                controller.checkParamToLoadProject();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 44,
                              padding: EdgeInsets.all(AppDimensions.sm),
                              margin: EdgeInsets.only(
                                right: AppDimensions.sm,
                                top: AppDimensions.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textWhite,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.sm,
                                ),
                              ),
                              child:
                                  controller.isFilterSelected.value == false
                                      ? SvgPicture.asset(
                                        SvgAssets.filterSvg,
                                        width: 16,
                                      )
                                      : SvgPicture.asset(
                                        SvgAssets.cancelSvg,
                                        width: 16,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Search and Filters Section
                    controller.isFilterSelected.value == true
                        ? Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Sectorwise Dropdown
                              Obx(
                                () => SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: AppDropdown<Category>(
                                    hintText: "Sector Wise",
                                    value: controller.selectedCategory.value,
                                    items: controller.category,
                                    itemLabel: (item) => item.name,
                                    onChanged: (value) {
                                      controller.selectedCategory.value = value;
                                      controller.isSectorDropdownOpen.value =
                                          false;
                                      if (controller.paramName.value !=
                                          "get_assigned") {
                                        controller.checkParamToLoadProject();
                                      }
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              //Year Wise Dropdown
                              Obx(
                                () => SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: AppDropdown<FinancialYearName>(
                                    hintText: "Year Wise",
                                    value: controller.selectedYear.value,
                                    items: controller.yearName,
                                    itemLabel: (item) => item.value ?? "",
                                    onChanged: (value) {
                                      controller.selectedYear.value = value;

                                      controller.isYearDropdownOpen.value =
                                          false;

                                      if (controller.paramName.value !=
                                          "get_assigned") {
                                        controller.checkParamToLoadProject();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : SizedBox.shrink(),

                    // Projects List
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return RefreshIndicator(
                            onRefresh: () async {
                              controller.loadProjects();
                            },
                            child:
                                controller.projects.isNotEmpty
                                    ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: AppDimensions.xs,
                                        vertical: AppDimensions.sm,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimensions.sm,
                                        vertical: AppDimensions.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.textWhite,
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.xs,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(2, 0),
                                          ),
                                        ],
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.projects.length,
                                        itemBuilder: (context, index) {
                                          final project =
                                              controller.projects[index];
                                          return BuildProjectCard(
                                            project:
                                                project.unitDetails ??
                                                UnitDetails(),
                                            onPressed: () {
                                              controller.onUpdateProgress(
                                                project:
                                                    project.unitDetails ??
                                                    UnitDetails(),
                                                projectStatus:
                                                    project.status ?? "",
                                                id:
                                                    controller
                                                                .paramName
                                                                .value ==
                                                            "pending"
                                                        ? project.id ?? ""
                                                        : "",
                                              );
                                            },
                                            isUrgent: false,
                                            isShowingCalendar:
                                                controller
                                                    .isShowingCalendar
                                                    .value,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: AppDimensions.sm,
                                          );
                                        },
                                      ),
                                    )
                                    : Center(
                                      child: TitleText(text: "No Data Found"),
                                    ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
