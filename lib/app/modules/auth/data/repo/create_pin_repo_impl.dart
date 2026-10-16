import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/data/model/create_pin_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/domain/repo/create_pin_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/verify_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';
import 'package:dio/dio.dart' as network;

class CreatePinRepoImpl extends CreatePinRepo with PopupMixin, SnackBarMixin {
  final ApiService apiService;
  CreatePinRepoImpl(this.apiService);

  @override
  Future<CreatePinResponseModel?> createPin({
    required String mobileNo,
    required String pin,
  }) async {
    final dio = Dio();

    final body = jsonEncode({"phoneNumber": mobileNo, "pin": pin});

    debugPrint("======================================");
    debugPrint("CREATE PIN REQUEST");
    debugPrint("URL: ${NetworkConstants.baseUrl}${NetworkConstants.createPin}");
    debugPrint("BODY: $body");
    debugPrint("======================================");

    try {
      final response = await dio.post(
        '${NetworkConstants.baseUrl}${NetworkConstants.createPin}',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint("======================================");
      debugPrint("CREATE PIN RESPONSE");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("DATA: ${response.data}");
      debugPrint("======================================");

      if (response.statusCode == HttpStatus.ok && response.data != null) {
        return CreatePinResponseModel.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      }

      final responseData =
          response.data is Map
              ? Map<String, dynamic>.from(response.data)
              : <String, dynamic>{};

      final modelData = CreatePinResponseModel(
        statusCode: responseData['statusCode']?.toString() ?? '',
        statusMessage:
            responseData['statusMessage']?.toString() ?? "Something Went Wrong",
        data: null,
      );

      showErrorDialog(
        Get.context!,
        title: "Error",
        message: modelData.statusMessage ?? "Something Went Wrong",
      );

      return modelData;
    } on DioException catch (e) {
      debugPrint("======================================");
      debugPrint("CREATE PIN DIO ERROR");
      debugPrint("TYPE: ${e.type}");
      debugPrint("STATUS: ${e.response?.statusCode}");
      debugPrint("MESSAGE: ${e.message}");
      debugPrint("DATA: ${e.response?.data}");
      debugPrint("REQUEST: ${e.requestOptions.data}");
      debugPrint("HEADERS: ${e.requestOptions.headers}");
      debugPrint("======================================");

      if (e.response?.data != null) {
        final responseData =
            e.response!.data is Map
                ? Map<String, dynamic>.from(e.response!.data)
                : <String, dynamic>{};

        final modelData = CreatePinResponseModel(
          statusCode:
              responseData['statusCode']?.toString() ??
              e.response?.statusCode?.toString() ??
              '',
          statusMessage:
              responseData['statusMessage']?.toString() ??
              "Something Went Wrong",
          data: null,
        );

        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.statusMessage ?? "Something Went Wrong",
        );

        return modelData;
      }

      return CreatePinResponseModel(
        statusCode: e.response?.statusCode?.toString() ?? '',
        statusMessage: e.message ?? "Something Went Wrong",
        data: null,
      );
    } catch (e) {
      debugPrint("CREATE PIN UNKNOWN ERROR: $e");

      return CreatePinResponseModel(
        statusCode: '',
        statusMessage: e.toString(),
        data: null,
      );
    }
  }

  @override
  Future<VerifyMobileOtpRespModel?> verifyPin({
    required String mobileNo,
    required String pin,
    required String fcmToken,
  }) async {
    final dio = Dio();

    final body = jsonEncode({
      "phoneNumber": mobileNo,
      "pin": pin,
      "fcmToken": fcmToken,
    });

    debugPrint("======================================");
    debugPrint("VERIFY PIN REQUEST");
    debugPrint("URL: ${NetworkConstants.baseUrl}${NetworkConstants.verifyPin}");
    debugPrint("BODY: $body");
    debugPrint("======================================");

    try {
      final response = await dio.post(
        '${NetworkConstants.baseUrl}${NetworkConstants.verifyPin}',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint("======================================");
      debugPrint("VERIFY PIN RESPONSE");
      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("DATA: ${response.data}");
      debugPrint("======================================");

      if (response.statusCode == 200 && response.data != null) {
        return VerifyMobileOtpRespModel.fromJson(
          Map<String, dynamic>.from(response.data),
        );
      }

      return VerifyMobileOtpRespModel(
        statusCode: response.statusCode.toString(),
        statusMessage: response.statusMessage,
        error: "Something Went Wrong",
      );
    } on DioException catch (e) {
      debugPrint("======================================");
      debugPrint("VERIFY PIN DIO ERROR");
      debugPrint("TYPE: ${e.type}");
      debugPrint("STATUS: ${e.response?.statusCode}");
      debugPrint("MESSAGE: ${e.message}");
      debugPrint("DATA: ${e.response?.data}");
      debugPrint("REQUEST: ${e.requestOptions.data}");
      debugPrint("HEADERS: ${e.requestOptions.headers}");
      debugPrint("======================================");

      if (e.response?.data != null) {
        final responseData = Map<String, dynamic>.from(e.response!.data);

        return VerifyMobileOtpRespModel(
          statusCode: e.response?.statusCode.toString(),
          statusMessage: responseData['statusMessage']?.toString(),
          error: responseData['error']?.toString(),
        );
      }

      return VerifyMobileOtpRespModel(
        statusCode: e.response?.statusCode.toString(),
        statusMessage: e.message,
        error: e.message ?? "Something Went Wrong",
      );
    } catch (e) {
      debugPrint("======================================");
      debugPrint("VERIFY PIN UNKNOWN ERROR");
      debugPrint(e.toString());
      debugPrint("======================================");

      return VerifyMobileOtpRespModel(error: e.toString());
    }
  }
}
