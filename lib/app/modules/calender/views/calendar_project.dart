import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/calender/controller/calendar_project_controller.dart';

import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// Work In Progress view
/// Displays all projects with "in_progress" status
class CalendarProject extends GetView<CalendarProjectController> {
  const CalendarProject({super.key});

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
          bottom: false,
          child: Column(
            children: [
              // Header
              WorkProgressHeader(
                title: "Project List",
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: ImageAssets.emblemImage,
                backIcon: Icons.arrow_back,
                widget: Column(
                  children: [
                    SizedBox(height: AppDimensions.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final pickerHeight = (constraints.maxWidth * 0.72)
                              .clamp(280.0, 320.0);
                          return SizedBox(
                            height: pickerHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.md,
                              ),
                              child: Obx(
                                () => SfDateRangePicker(
                                  showActionButtons: false,
                                  backgroundColor: AppColors.textWhite,
                                  selectionColor: AppColors.primary,
                                  todayHighlightColor: AppColors.primary,

                                  initialDisplayDate:
                                      controller.imageAttachmentDates.isNotEmpty
                                          ? controller
                                              .imageAttachmentDates
                                              .first
                                          : DateTime.now(),
                                  selectableDayPredicate:
                                      controller.hasImageAttachmentOnDate,
                                  monthViewSettings:
                                      DateRangePickerMonthViewSettings(
                                        specialDates:
                                            controller.imageAttachmentDates
                                                .toList(),
                                      ),
                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                    specialDatesDecoration: BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    specialDatesTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    disabledDatesTextStyle: TextStyle(
                                      color: AppColors.textSecondary.withValues(
                                        alpha: 0.35,
                                      ),
                                    ),
                                  ),
                                  onSelectionChanged:
                                      controller.onSelectionChanged,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppDimensions.s),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.40,
                    //     height: 40,
                    //     margin: EdgeInsets.only(right: AppDimensions.sm1),
                    //     child: AuthSubmitButton(
                    //       title: "Submit Date",
                    //       isEnabled: true,
                    //       isAuthButton: true,
                    //       onPressed: () {
                    //         controller.validateDate();
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    // Projects List
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            controller.loadProjects();
                          },
                          child:
                              controller.projects.isNotEmpty
                                  ? ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    itemCount: controller.projects.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final project =
                                          controller.projects[index];
                                      return BuildProjectCard(
                                        project.project ?? ProjectDetails(),
                                        () {
                                          controller.onUpdateProgress(
                                            controller
                                                    .projects[index]
                                                    .project ??
                                                ProjectDetails(),
                                          );
                                        },
                                        false,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: AppDimensions.sm);
                                    },
                                  )
                                  : Center(
                                    child: TitleText(text: "No Data Found"),
                                  ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
