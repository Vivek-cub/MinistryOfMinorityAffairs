
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category_response.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';

abstract class ProjectListRepo {
  Future<ProjectResponse?> getProjectList({required String status,required String paramName,required String sectorId});
  Future<ProjectResponse?> getProjectListByGeoTagged({required bool status,required String paramName, required String sectorId});
  Future<CategoryResponse?> getAllSector();

}