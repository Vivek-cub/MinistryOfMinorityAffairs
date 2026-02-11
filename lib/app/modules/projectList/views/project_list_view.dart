import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

/// Work In Progress view
/// Displays all projects with "in_progress" status
class ProjectListView extends GetView<ProjectsListController> {
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
                  children: [
                    // Header
                    WorkProgressHeader(
                      //title: controller.screenTitle,
                      title: "Project List",
                      subtitle: 'Track Progress of works in real-time',
                      avatarAssetPath: ImageAssets.emblemImage,
                    ),
                    // Search and Filters Section
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.40,
                            child: SearchBarWidget(
                              hintText: 'Search',
                              onChanged: controller.onSearchChanged,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sector Wise Dropdown
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.40,
                            child: FilterDropdown<Category>(
                              label: 'Sector Wise',
                              selectedValue: controller.selectedCategory.value,
                              items: controller.category,
                              isOpen: controller.isSectorDropdownOpen.value,
                              onTap: controller.toggleSectorDropdown,
                              itemBuilder: (category) => category.name,
                              onChanged: (value){
                                controller.selectedCategory.value = value;
                                controller.isSectorDropdownOpen.value = false;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Year Wise Dropdown
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.40,
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
                        }else{
                          return RefreshIndicator(
                          onRefresh: ()async{
                            controller.loadProjects();
                          },
                          child: controller.projects.isNotEmpty
                          ?ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.projects.length,
                            itemBuilder: (context, index) {
                              final project =
                                  controller.projects[index];
                                  return BuildProjectCard(
                                    project.project??ProjectDetails(),
                                     (){
                                      controller.onUpdateProgress(controller.projects[index].project??ProjectDetails());
                                     }
                                     );
                              
                            },
                            separatorBuilder: (context,index){
                              return SizedBox(height: AppDimensions.s,);
                            },
                          )
                          :Center(
                            child: TitleText(text: "No Data Found"),
                          ),
                        );
                        }                        
                      }),
                    ),
                  ],
                ),
                // Sector Wise Dropdown Menu
                if (controller.isSectorDropdownOpen.value)
                  Positioned(
                    top: 220, // Header height + padding + dropdown height
                    left: 120, // 16 (padding) + 120 (search) + 12 (spacing)
                    child: FilterDropdownMenu<Category>(
                      width: 200,
                      items: controller.category,
                      itemBuilder: (category) => category.name,
                      onItemSelected: (value){
                        controller.selectedCategory.value = value;
                                controller.isSectorDropdownOpen.value = false;
                                if(controller.paramName.value !="get_assigned"){
                                  controller.checkParamToLoadProject();
                                }
                                
                      },
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
