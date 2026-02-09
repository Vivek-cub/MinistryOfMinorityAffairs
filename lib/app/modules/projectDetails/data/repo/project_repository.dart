
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

class ProjectRepository {
  final ProjectDao dao;
  ProjectRepository(this.dao);

  Future<void> saveProject(ProjectDetails project) {
    return dao.saveProject(project);
  }
}
