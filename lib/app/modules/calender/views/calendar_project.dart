import 'package:custom_date_range_picker/custom_date_range_picker.dart';
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
          bottom: true,
          child: Column(
            children: [
              // Header
              WorkProgressHeader(
                //title: controller.screenTitle,
                title: "Project List",
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: ImageAssets.emblemImage,
                backIcon: Icons.arrow_back,
                // widget: SizedBox(
                //   //height: 400,
                //   child: CustomDateRangePicker(
                //     minimumDate: DateTime.now().subtract(
                //       const Duration(days: 30),
                //     ),
                //     maximumDate: DateTime.now().add(const Duration(days: 30)),
                //     backgroundColor: Colors.white,
                //     primaryColor: Colors.green,
                //     onApplyClick: (start, end) {
                //       controller.validateDate();
                //     },
                //     onCancelClick: () {},
                //   ),
                // ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   child: LayoutBuilder(
                    //     builder: (context, constraints) {
                    //       final pickerHeight = (constraints.maxWidth * 0.82)
                    //           .clamp(280.0, 330.0);
                    //       return SizedBox(
                    //         height: pickerHeight,
                    //         child: SfDateRangePicker(
                    //           showActionButtons: false,
                    //           backgroundColor: Colors.transparent,
                    //           onSelectionChanged: controller.onSelectionChanged,
                    //           selectionMode: DateRangePickerSelectionMode.range,
                    //           initialSelectedRange: PickerDateRange(
                    //             DateTime.now().subtract(const Duration(days: 4)),
                    //             DateTime.now().add(const Duration(days: 3)),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.40,
                    //     height: 40,
                    //     margin: EdgeInsets.only(right: AppDimensions.sm1),
                    //     child: AuthSubmitButton(
                    //       title: "Submit Date",
                    //       isEnabled: true,
                    //       onPressed: () {
                    //         controller.validateDate();
                    //       },
                    //     ),
                    //   ),
                    // ),

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
