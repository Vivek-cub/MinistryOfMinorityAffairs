
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category_response.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';

abstract class ProjectListRepo {
  Future<ProjectResponse?> getProjectList({required String status,required String paramName,required String sectorId,required String year, required String startDate, required String endDate});
  Future<ProjectResponse?> getProjectListByGeoTagged({required bool status,required String paramName, required String sectorId,required String year, required String startDate, required String endDate});
  Future<CategoryResponse?> getAllSector();
  Future<ProjectResponse?> getAssignedProjects();

}