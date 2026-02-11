
import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/category_response.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/domain/repo/project_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class ProjectListRepoImpl extends ProjectListRepo with SnackBarMixin,PopupMixin{
  final ApiService apiService;
  ProjectListRepoImpl(this.apiService);
  @override
  Future<ProjectResponse?> getProjectList({required String status,required String paramName,required String sectorId}) async{
    try{
      final resp = await apiService.get(
        NetworkConstants.projectList,
        query: {
          paramName:status,
          "sectorId":sectorId
          },
      );
      if (resp.statusCode == HttpStatus.ok) {
        return ProjectResponse.fromJson(resp.data);
      }else{
        ProjectResponse modelData = ProjectResponse();
        showErrorDialog(
          Get.context!,
            title: "Error",
            message: modelData.statusMessage??"Something Went Wrong",);
        return modelData;
      }
    }catch(e){
        throw Exception(e);
    }
  }
  @override
  Future<ProjectResponse?> getProjectListByGeoTagged({required bool status,required String paramName,required String sectorId}) async{
    try{
      final resp = await apiService.get(
        NetworkConstants.projectList,
        query: {
          paramName:status,
          "sectorId":sectorId
          },
      );
      if (resp.statusCode == HttpStatus.ok) {
        return ProjectResponse.fromJson(resp.data);
      }else{
        ProjectResponse modelData = ProjectResponse();
        showErrorDialog(
          Get.context!,
            title: "Error",
            message: modelData.statusMessage??"Something Went Wrong",);
        return modelData;
      }
    }catch(e){
        throw Exception(e);
    }
  }

  @override
  Future<CategoryResponse?> getAllSector() async{
    try{
      final resp = await apiService.get(
        NetworkConstants.getAllSector,
      );
      if (resp.statusCode == HttpStatus.ok) {
        return CategoryResponse.fromJson(resp.data);
      }else{
        CategoryResponse modelData = CategoryResponse();
        showErrorDialog(
          Get.context!,
            title: "Error",
            message: modelData.statusMessage??"Something Went Wrong",);
        return modelData;
      }
    }catch(e){
        throw Exception(e);
    }
  }

  @override
  Future<ProjectResponse?> getAssignedProjects() async{
    try{
      final resp = await apiService.get(
        NetworkConstants.assignedProjectList,
      );
      if (resp.statusCode == HttpStatus.ok) {
        return ProjectResponse.fromJson(resp.data);
      }else{
        ProjectResponse modelData = ProjectResponse();
        showErrorDialog(
          Get.context!,
            title: "Error",
            message: modelData.statusMessage??"Something Went Wrong",);
        return modelData;
      }
    }catch(e){
        throw Exception(e);
    }
  }
}