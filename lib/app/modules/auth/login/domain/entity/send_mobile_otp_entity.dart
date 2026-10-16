import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/send_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/send_mobile_otp_data.dart';

class SendMobileOtpEntity {
  String? statusCode;
  String? statusMessage;
  String? error;
  SendMobileOtpData? data;

  SendMobileOtpEntity({
    this.statusCode,
    this.statusMessage,
    this.error,
    this.data,
  });
}
