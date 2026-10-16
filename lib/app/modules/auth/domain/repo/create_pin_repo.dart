import 'package:ministry_of_minority_affairs/app/modules/auth/data/model/create_pin_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/verify_mobile_otp_resp_model.dart';

abstract class CreatePinRepo {
  Future<CreatePinResponseModel?> createPin({
    required String mobileNo,
    required String pin,
  });
  Future<VerifyMobileOtpRespModel?> verifyPin({
    required String mobileNo,
    required String pin,
    required String fcmToken,
  });
}
