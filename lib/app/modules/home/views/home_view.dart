import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_drawer.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_stat_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_work_list.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import '../controllers/home_controller.dart';

/// Home screen view
/// Main landing screen of the application
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
        drawer: BuildDrawer(controller: controller,),
        body: SafeArea(
          top: false,
          bottom: true,
          child: Obx(
            (){
            return controller.hasInternet.value==true? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_buildHeader(context),
                WorkProgressHeader(
                  title: "Welcome ${controller.userName.value}",
                  subtitle: "Track Progress of works in real-time",
                  avatarAssetPath: ImageAssets.emblemImage,
                  onAvatarTap: (){
                    Scaffold.of(context).openDrawer();
                  },
                ),
                _buildQuickOverview(context),
                
                BuildWorkList(controller: controller,),
                const SizedBox(height: AppDimensions.sm),
              ],
            ),
          )
          : Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(text: "No Intenet"),
                const SizedBox(height: 24,),
                AuthSubmitButton(
                  title: "Open Project List",
                  isEnabled: true,
                  onPressed: (){
                    Get.offNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "noInternet",
                            'paramName': "noInternet",
                            'statusFilter': "",
                          },
                        );
                  },
                  )
              ],
            ),
            );
            }
          ),
        ),
      ),
    );
  }

  
  Widget _buildQuickOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: 'Quick Overview',
            fontWeight: FontWeight.bold,
            ),
          
          const SizedBox(height: 16),
          Obx(() {
            final data = controller.data.value;

            if (data == null) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BuildStatCard(
                                        title: 'Assigned Projects',
                                        value: data.totalAssigned??0,
                                        icon: IconAssets.assignedTask,
                                        backgroundColor: Colors.blue.withOpacity(0.1),
                                        iconColor: Colors.blue,
                                        
                                      ),
                                      
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: BuildStatCard(
                        title: 'Not Started',
                        value: controller.data.value.notStarted??0,
                        icon: IconAssets.workInProgress,
                        backgroundColor: Colors.red.withOpacity(0.1),
                        iconColor: Colors.red,
                        onTap: (){
                          Get.toNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "NotStarted",
                            'paramName': "status",
                            'statusFilter': "not_started",
                          },
                        );
                        },
                      ),
                    ),
                  ],
                  ),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    
                    
                    Expanded(
                      child: BuildStatCard(
                        title: 'Work in Progress',
                        value: controller.data.value.inProgress??0,
                        icon: IconAssets.workInProgress,
                        backgroundColor: Colors.orange.withOpacity(0.1),
                        iconColor: Colors.orange,
                        onTap: () {
                          Get.toNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "Assigned",
                            'paramName': "status",
                            'statusFilter': "in_progress",
                          },
                        );
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: BuildStatCard(
                        title: 'Completed',
                        value: controller.data.value.totalCompleted??0,
                        icon: IconAssets.completedTask,
                        backgroundColor: Colors.green.withOpacity(0.1),
                        iconColor: Colors.green,
                        onTap: (){Get.toNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "Completed",
                            'paramName': "status",
                            'statusFilter': "completed",
                          },
                        );},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: BuildStatCard(
                        title: 'Geotagged',
                        value: controller.data.value.geoTagged??0,
                        icon: IconAssets.geotagged,
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        iconColor: Colors.blue,
                        onTap: (){Get.toNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "",
                            'paramName': "geoTagged",
                            'statusFilter': "",
                            'geoStatus':true
                          },
                        );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BuildStatCard(
                        title: 'Non-Geotagged',
                        value: controller.data.value.nonGeoTagged??0,
                        icon: IconAssets.nonGeotagged,
                        backgroundColor: Colors.brown.withOpacity(0.1),
                        iconColor: Colors.brown,
                        onTap: (){Get.toNamed(
                          AppRoutes.projectList,
                          arguments: {
                            'status': "",
                            'paramName': "geoTagged",
                            'statusFilter': "",
                            'geoStatus':false
                          },
                        );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
