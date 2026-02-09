
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/send_mobile_otp_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/verify_mobile_otp.dart';

class VerifyMobileOtpRespModel extends VerifyMobileOtp {
  VerifyMobileOtpRespModel({
    super.statusCode,
    super.statusMessage,
    super.error,
    super.data,
  });

  factory VerifyMobileOtpRespModel.fromJson(Map<String, dynamic> json) =>
      VerifyMobileOtpRespModel(
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        error: json['error'],
        data: json['data'] != null
            ? SendMobileOtpData.fromJson(
                json['data'],
              )
            : null,
      );
}