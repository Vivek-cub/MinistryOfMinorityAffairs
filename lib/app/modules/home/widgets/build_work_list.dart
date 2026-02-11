import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

class BuildWorkList extends StatelessWidget {
  HomeController controller;
  BuildWorkList({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                text: 'Work List',
                fontWeight: FontWeight.bold,
              ),
              
              TextButton(
                onPressed: controller.onViewAllTap,
                child: const CustomText(text: "View All",color: AppColors.primaryDark,),
              ),
            ],
          ),
          
          Obx(() {
            final projects = controller.projects.take(3).toList();
            return Column(
              children:
                  projects.map((project) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BuildProjectCard(
                        project.project??ProjectDetails(), 
                        (){
                          controller.onUpdateProgressTap(project.project??ProjectDetails());
                        }
                        ),
                      //child: _buildProjectCard(project.project??ProjectDetails()),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}