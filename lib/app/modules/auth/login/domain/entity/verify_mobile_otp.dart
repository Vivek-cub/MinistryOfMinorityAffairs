
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/send_mobile_otp_data.dart';

class VerifyMobileOtp {

  String? statusCode;
  String? statusMessage;
  String? error;
  SendMobileOtpData? data;

  VerifyMobileOtp({
    this.statusCode,
    this.statusMessage,
    this.error,
    this.data,
  });
}
