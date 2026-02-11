import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';

class BuildStatCard extends StatelessWidget {
    final String? title;
    final int? value;
    final String? icon;
    final Color? backgroundColor;
    final Color? iconColor;
    final VoidCallback? onTap;
   BuildStatCard(
     {this.title,
     this.value,
     this.icon,
     this.backgroundColor,
     this.iconColor,
    this.onTap,}
    );

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: cardContainer(),
        ),
      );
  }

  Widget cardContainer(){
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: cardContent(),
    );
  }

  Widget cardContent(){
      return Column(
              children: [
                Container(
                 
                  height: 24,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    
                  ),
                  child: Image.asset(icon??"",color: AppColors.primaryDark,),
                ),
               //const SizedBox(height: 12),
                CustomText(text: title??"",textAlign: TextAlign.center,),
                HeaderText(text: value.toString()),
                
              ],
            );
  }
}