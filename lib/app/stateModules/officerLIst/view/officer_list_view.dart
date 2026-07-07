import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_officer_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_urgent_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/long_pending_officer_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/financial_year_name.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';

import 'package:ministry_of_minority_affairs/app/modules/projectList/widget/app_dropdown.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/controller/officer_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/view/officer_list_card.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class OfficerListView extends GetView<OfficerListController> {
  const OfficerListView({super.key});

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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  WorkProgressHeader(
                    //title: controller.screenTitle,
                    title: "Officer List",
                    subtitle: 'Track Progress of works in real-time',
                    avatarAssetPath: ImageAssets.emblemImage,
                    backIcon: Icons.arrow_back,
                    // widget: Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         // width: MediaQuery.of(context).size.width * 0.75,
                    //         margin: EdgeInsets.only(
                    //           top: AppDimensions.md,
                    //           left: AppDimensions.sm,
                    //           right: AppDimensions.sm,
                    //         ),

                    //         child: SearchBarWidget(
                    //           hintText: 'Search',
                    //           onChanged: controller.onSearchChanged,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),

                  // Officers List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            controller.loadProjects();
                          },
                          child:
                              controller.fieldOfficers.isNotEmpty
                                  ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.sm,
                                      vertical: AppDimensions.md,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: AppColors.textWhite,
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.xs,
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withValues(
                                      //       alpha: 0.1,
                                      //     ),
                                      //     blurRadius: 4,
                                      //     offset: const Offset(0, 2),
                                      //   ),
                                      //   BoxShadow(
                                      //     color: Colors.black.withValues(
                                      //       alpha: 0.1,
                                      //     ),
                                      //     blurRadius: 4,
                                      //     offset: const Offset(2, 0),
                                      //   ),
                                      // ],
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          controller.fieldOfficers.length,
                                      itemBuilder: (context, index) {
                                        final project =
                                            controller.fieldOfficers[index];

                                        return OfficerListCard(
                                          project: project,
                                          onPressed: () {
                                            Get.toNamed(
                                              AppRoutes.projectList,
                                              arguments: {
                                                "paramName": "officer",
                                                "userId": project.id,
                                                "officerName": project.name,
                                              },
                                            );
                                          },
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
                                    // child: TitleText(text: "No Data Found"),
                                    child: SizedBox(),
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
    );
  }
}
