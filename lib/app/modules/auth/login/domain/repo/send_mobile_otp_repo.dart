import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/send_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/verify_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/verify_mobile_otp.dart';

abstract class SendMobileOtpRepo {
  Future<SendMobileOtpRespModel?> sendMobileOtp({
      required String mobileNo
  });
  Future<VerifyMobileOtpRespModel?> verifyOTP({
      required String mobileNo,required String otp
  });
}