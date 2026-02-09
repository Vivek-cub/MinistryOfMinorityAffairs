
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as network;
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';


mixin class DioErrorHandler {
  static bool _isErrorDialogShowing = false;
  static Timer? _dialogResetTimer;

  void errorHandler(
    network.DioException e, [
    bool skipAlert = false,
    String title = "Error",
    String message = "Something went wrong",
  ]) async {
    switch (e.type) {
      case network.DioExceptionType.connectionTimeout:
        title = "Connection Timeout";
        message = "Please check your internet connection and try again.";
        break;

      case network.DioExceptionType.sendTimeout:
        title = "Request Timeout";
        message = "Request timeout. Please try again.";
        break;

      case network.DioExceptionType.receiveTimeout:
        title = "Response Timeout";
        message = "Server response timeout. Please try again.";
        break;

      case network.DioExceptionType.badResponse:
        _handleBadResponse(
          e.response,
          title,
          message,
          skipAlert,
        );
        return;

      case network.DioExceptionType.cancel:
        return;

      case network.DioExceptionType.connectionError:
        if (e.error is SocketException) {
          title = "No Internet Connection";
          message = "Please check your internet connection and try again.";
        } else {
          title = "Connection Error";
          message =
              "Unable to connect to server. Please check your internet connection.";
        }
        break;

      case network.DioExceptionType.badCertificate:
        title = "Error";
        message = "SSL error please contact to help desk.";
        break;

      case network.DioExceptionType.unknown:
        if (e.error is SocketException) {
          title = "No Internet Connection";
          message = "Please check your internet connection and try again.";
        } else {
          title = title;
          message = e.message ?? message;
        }
        break;
    }

    if (!skipAlert) {
      _showErrorDialogSafely(title, message);
    }
  }

  void _showErrorDialogSafely(String title, String message) {
    if (_isErrorDialogShowing) {
      return;
    }

    _isErrorDialogShowing = true;

    _dialogResetTimer?.cancel();

    if (Get.isRegistered<ApiService>()) {
      Get.find<ApiService>().isAlertVisible(true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Get.context == null) {
        _resetErrorDialogFlag();
        return;
      }

      try {
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          IconAssets.error,
                          height: AppDimensions.sideIndicator2Height,
                          width: AppDimensions.sideIndicator2Height,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          style: Get.textTheme.displaySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        AuthSubmitButton(
                          title: "OK",
                          isEnabled: true,
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('Error showing dialog: $e');
      } finally {
        _resetErrorDialogFlag();
      }
    });
  }

  void _handleBadResponse(
    network.Response? response,
    String title,
    String message, [
    bool skipAlert = false,
  ]) {
    if (_isErrorDialogShowing) {
      return;
    }

    String? serverMessage = _extractServerMessage(response);
    String finalTitle = title;
    String finalMessage = message;

    if (serverMessage != null && serverMessage.isNotEmpty) {
      dynamic data;
      try {
        data = jsonDecode(serverMessage);
      } catch (e) {
        data = serverMessage;
      }

      if (data != null && data is Map?) {
        finalMessage = data?["message"] ?? message;
      } else {
        finalMessage = serverMessage;
      }

      finalTitle = _getTitleForStatusCode(response?.statusCode) ?? title;
    } else {
      switch (response?.statusCode) {
        case 400:
          finalTitle = "Bad Request";
          finalMessage =
              "Invalid request. Please check your input and try again.";
          break;
        case 401:
          finalTitle = "Error";
          finalMessage = "Please log in again to continue.";
          break;
        case 403:
          finalTitle = "Error";
          finalMessage = "Something went wrong";
          break;
        case 404:
          finalTitle = "Not Found";
          finalMessage = "The requested resource was not found.";
          break;
        case 408:
          finalTitle = "Request Timeout";
          finalMessage = "Request timeout. Please try again.";
          break;
        case 429:
          finalTitle = "Too Many Requests";
          finalMessage =
              "Too many requests. Please wait a moment and try again.";
          break;
        case 500:
          finalTitle = "Server Error";
          finalMessage = "Internal server error. Please try again later.";
          break;
        case 502:
          finalTitle = "Bad Gateway";
          finalMessage =
              "Server is temporarily unavailable. Please try again later.";
          break;
        case 503:
          finalTitle = "Service Unavailable";
          finalMessage =
              "Service is temporarily unavailable. Please try again later.";
          break;
        case 504:
          finalTitle = "Gateway Timeout";
          finalMessage = "Server response timeout. Please try again later.";
          break;
        default:
          break;
      }
    }

    if (!skipAlert) {
      _showBadResponseErrorDialog(response, finalTitle, finalMessage);
    }
  }

  void _showBadResponseErrorDialog(
    network.Response? response,
    String title,
    String message,
  ) {
    _isErrorDialogShowing = true;

    _dialogResetTimer?.cancel();

    if (Get.isRegistered<ApiService>()) {
      Get.find<ApiService>().isAlertVisible(true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Get.context == null) {
        _resetErrorDialogFlag();
        return;
      }

      try {
        await showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          IconAssets.error,
                          height: AppDimensions.sideIndicator2Height,
                          width: AppDimensions.sideIndicator2Height,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          title,
                          style: Get.textTheme.displaySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        AuthSubmitButton(
                          title: "OK",
                          isEnabled: true,
                          onPressed: () async{
                            if (response?.statusCode == 401 &&
                                RegExp(
                                  r'expired|jwt',
                                  caseSensitive: false,
                                ).hasMatch(message.trim())) {
                              if (Get.isRegistered<AuthService>()) {
                                await Get.find<AuthService>().onLogout();
                                if (Get.context != null) {
                                  Navigator.pop(Get.context!);
                                }
                                Get.offAllNamed(
                                  AppRoutes.login,
                                );
                              }
                            } else if (RegExp(r'expired|jwt',
                                    caseSensitive: false)
                                .hasMatch(message.trim())) {
                              if (Get.isRegistered<AuthService>()) {
                                await Get.find<AuthService>().onLogout();
                                if (Get.context != null) {
                                  Navigator.pop(Get.context!);
                                }
                                Get.offAllNamed(
                                  AppRoutes.home,
                                );
                              }
                            } else {
                              Navigator.pop(dialogContext);
                            }
                          },
                          )
                        
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
        debugPrint('Error showing dialog: $e');
      } finally {
        _resetErrorDialogFlag();
      }
    });
  }

  void _resetErrorDialogFlag() {
    _isErrorDialogShowing = false;

    if (Get.isRegistered<ApiService>()) {
      Get.find<ApiService>().isAlertVisible(false);
    }

    _dialogResetTimer = Timer(const Duration(seconds: 5), () {
      _isErrorDialogShowing = false;
      if (Get.isRegistered<ApiService>()) {
        Get.find<ApiService>().isAlertVisible(false);
      }
    });
  }

  String? _extractServerMessage(network.Response? response) {
    if (response?.data == null) return null;

    if (response?.data is String) {
      if (response?.statusCode != null && (response?.statusCode ?? 0) > 500) {
        return null;
      }
      String stringData = response!.data as String;
      return stringData.isNotEmpty ? stringData : null;
    } else if (response?.data is Map) {
      Map<String, dynamic> mapData = response!.data as Map<String, dynamic>;

      List<String> possibleFields = [
        'message',
        'error',
        'error_message',
        'statusMessage',
        'msg',
        'description'
      ];

      for (String field in possibleFields) {
        if (mapData.containsKey(field) && mapData[field] != null) {
          String fieldValue = mapData[field].toString();
          if (fieldValue.isNotEmpty) {
            return fieldValue;
          }
        }
      }
    }

    return null;
  }

  String? _getTitleForStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad Request";
      case 401:
        return "Error";
      case 403:
        return "Error";
      case 404:
        return "Not Found";
      case 408:
        return "Request Timeout";
      case 429:
        return "Too Many Requests";
      case 500:
        return "Server Error";
      case 502:
        return "Bad Gateway";
      case 503:
        return "Service Unavailable";
      case 504:
        return "Gateway Timeout";
      default:
        return null;
    }
  }

  static void resetErrorDialogFlag() {
    _isErrorDialogShowing = false;
    _dialogResetTimer?.cancel();
  }
}
