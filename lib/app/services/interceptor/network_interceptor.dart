import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final hasInternet = await NetworkService.hasInternet();

    if (!hasInternet) {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );

      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No Internet Connection',
        ),
      );
    }

    handler.next(options);
  }
}
