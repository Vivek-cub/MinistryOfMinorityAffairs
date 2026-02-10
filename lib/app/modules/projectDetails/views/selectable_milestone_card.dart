import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
class SelectableMilestoneCard extends StatelessWidget {
  final ProjectMilestone milestone;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableMilestoneCard({
    super.key,
    required this.milestone,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        isSelected ? Colors.green : Colors.grey.shade300;

    final Color bgColor =
        isSelected ? Colors.green.shade50 : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milestone.milestoneName??"Milestone",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    milestone.milestoneDescription??"",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            // if (milestone.status == "Completed")
            //   const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
