import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/data/officer_list_response_model.dart';

class OfficerListCard extends StatelessWidget {
  final FieldOfficers project;
  final VoidCallback? onPressed;
  const OfficerListCard({
    super.key,
    required this.project,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.textHint),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header

          /// User Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                /// Top Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    project.profilePath != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            project.profilePath ?? "",
                            height: 30,
                            width: 30,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(Icons.person, size: 30),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(text: project.name ?? ""),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              Icon(
                                Icons.badge,
                                size: 16,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              CustomText(text: "Field Officer"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                _buildInfoRow(
                  Icons.location_on,
                  project.blockName ??
                      project.districtName ??
                      project.stateName ??
                      "",
                ),

                /// Phone
                _buildInfoRow(Icons.call, project.phoneNumber ?? ""),

                const SizedBox(height: 22),

                /// Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xffF7B347), Color(0xffFF6F6F)],
                        ),
                      ),
                      child: const Center(
                        child: TitleText(
                          text: "View Details",
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 12),
        Expanded(child: CustomText(text: text)),
      ],
    );
  }
}
