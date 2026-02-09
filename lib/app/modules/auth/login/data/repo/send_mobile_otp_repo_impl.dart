
import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/send_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/verify_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class SendMobileOtpRepoImpl extends SendMobileOtpRepo with PopupMixin,SnackBarMixin{

  final ApiService apiService;
  SendMobileOtpRepoImpl(this.apiService);

  @override
  Future<SendMobileOtpRespModel?> sendMobileOtp({required String mobileNo}) async{
    
    try{
      final resp = await apiService.post(
        NetworkConstants.login,
        data: {"phoneNumber":mobileNo},
      );
      if (resp.statusCode == HttpStatus.ok) {
        return SendMobileOtpRespModel.fromJson(resp.data);
      }else{
        SendMobileOtpRespModel modelData = SendMobileOtpRespModel();
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
  Future<VerifyMobileOtpRespModel?> verifyOTP({required String mobileNo, required String otp}) async{
    try{
      final resp = await apiService.post(
      NetworkConstants.verifyOtp,
      data: {"phoneNumber":mobileNo,"otp":otp},
    );
    if (resp.statusCode == HttpStatus.ok) {
        return VerifyMobileOtpRespModel.fromJson(resp.data);
      }else{
        VerifyMobileOtpRespModel modelData = VerifyMobileOtpRespModel();
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