
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/send_mobile_otp_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/entity/send_mobile_otp_entity.dart';

class SendMobileOtpRespModel extends SendMobileOtpEntity {
  SendMobileOtpRespModel({
    super.statusCode,
    super.statusMessage,
    super.error,
    //super.data,
  });

  factory SendMobileOtpRespModel.fromJson(Map<String, dynamic> json) =>
      SendMobileOtpRespModel(
        statusCode: json['statusCode'],
        statusMessage: json['statusMessage'],
        error: json['error'],
        // data: json['data'] != null
        //     ? SendMobileOtpData.fromJson(
        //         json['data'],
        //       )
        //     : null,
      );
}
