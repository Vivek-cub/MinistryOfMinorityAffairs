
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class HomeRepoImpl extends HomeRepo with PopupMixin,SnackBarMixin{
  final ApiService apiService;
  HomeRepoImpl(this.apiService);
  
  @override
  Future<HomeRespModel?> getHomeData() async{
    try{
      final resp = await apiService.get(
        NetworkConstants.dashboard,
      );
      if (resp.statusCode == HttpStatus.ok) {
        return HomeRespModel.fromJson(resp.data);
      }else{
        HomeRespModel modelData = HomeRespModel();
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