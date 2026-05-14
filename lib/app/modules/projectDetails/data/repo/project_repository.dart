import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_db_helper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/milestone_attachment_mapper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';

class ProjectRepository {
  final ProjectDao dao;
  ProjectRepository(this.dao);

  Future<void> saveProject(ProjectDetails project, String userId) {
    return dao.saveProject(project, userId);
  }

  Future<List<ProjectDetails>> getLocalProjects(String userId) async {
    final data = await dao.getAllProjectsFull(userId);
    return data.map(mapToProjectDetails).toList();
  }

  ProjectDetails mapToProjectDetails(LocalProjectFull local) {
    return ProjectDetails(
      id: local.project.projectId,
      projectName: local.project.projectName,
      status: local.project.status,
      lat: local.project.lat,
      lng: local.project.lng,
      address: local.project.address,
      createdAt: local.project.createdAt,
      districtId: local.project.districtId,
      projectUniqueId: local.project.projectUniqueId,
      videoAtt: local.video,
      milestones:
          local.milestones.map((m) {
            return ProjectMilestone(
              id: m.milestone.milestoneId,
              milestoneName: m.milestone.name,
              milestoneDescription: m.milestone.description,
              status: m.milestone.status,
              imageAtt: MilestoneAttachmentMapper.toImageAttachments(m.images),
              audioAtt: MilestoneAttachmentMapper.toAudioAttachments(m.audio),
              progress: m.milestone.progress,
            );
          }).toList(),
    );
  }

  Future<void> clearLocalDataForUser(String userId) {
    return dao.clearLocalDataForUser(userId);
  }
}
