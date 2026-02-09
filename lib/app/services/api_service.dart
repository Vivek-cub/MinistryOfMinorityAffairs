import 'package:dio/dio.dart' as network;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/dio_error_handler.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/interceptor/network_interceptor.dart';
import 'package:ministry_of_minority_affairs/curl_interceptor.dart';


class ApiService extends GetxService {
  final network.Dio _dio = network.Dio();
  RxBool isAlertVisible = RxBool(false);

  @override
void onInit() {
  _dio.options.baseUrl = "http://49.249.23.234:80/api/v1/";
  _dio.options.connectTimeout = const Duration(minutes: 3);
  _dio.options.receiveTimeout = const Duration(minutes: 3);

_dio.interceptors.add(NetworkInterceptor());
  _dio.interceptors.add(
    RetryInterceptor(
      dio: _dio,
      retries: 3,
      logPrint: print,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 5),
        Duration(seconds: 8),
      ],
      retryEvaluator: (error, attempt) {
        return error.type == network.DioExceptionType.connectionTimeout ||
            error.type == network.DioExceptionType.receiveTimeout ||
            error.type == network.DioExceptionType.sendTimeout ||
            error.type == network.DioExceptionType.connectionError ||
            (error.response?.statusCode != null &&
                [500, 502, 503, 504]
                    .contains(error.response!.statusCode));
      },
    ),
  );

  // 🧾 cURL SECOND (final request snapshot)
  _dio.interceptors.add(CurlInterceptor());

  // 🪵 Logging / auth / headers LAST
  _dio.interceptors.add(DioInterceptor());

  super.onInit();
}


  Future<network.Response<dynamic>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    network.Options? options,
    network.CancelToken? cancelToken,
    network.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  Future<network.Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    network.Options? options,
    network.CancelToken? cancelToken,
    network.ProgressCallback? onSendProgress,
    network.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }

  Future<network.Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    network.Options? options,
    network.CancelToken? cancelToken,
    network.ProgressCallback? onSendProgress,
    network.ProgressCallback? onReceiveProgress,
  }) {
    return _dio.put(
      path,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      options: options,
    );
  }
}

class DioInterceptor extends network.InterceptorsWrapper with DioErrorHandler {
  static final Map<String, int> _errorCounts = {};

  @override
  void onRequest(
    network.RequestOptions options,
    network.RequestInterceptorHandler handler,
  ) {
    final token = Get.find<AuthService>().getToken;
    if (token != null) {
      options.headers.addAll({
        "Authorization": "Bearer $token",
      });
    }
    options.headers.addAll({
      'X-Client': 'mobile',
    });

    final requestKey = '${options.method}_${options.path}_${options.hashCode}';

    if (!_errorCounts.containsKey(requestKey)) {
      _errorCounts[requestKey] = 0;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(
    network.DioException err,
    network.ErrorInterceptorHandler handler,
  ) {
    final requestKey =
        '${err.requestOptions.method}_${err.requestOptions.path}_${err.requestOptions.hashCode}';

    _errorCounts[requestKey] = (_errorCounts[requestKey] ?? 0) + 1;

    final isRetryableError = _isRetryableError(err);
    final errorCount = _errorCounts[requestKey] ?? 1;

    final shouldShowError = !isRetryableError || errorCount > 3;

    if (shouldShowError) {
      errorHandler(err, _shouldSkipAlert());
      _errorCounts.remove(requestKey);
    } else {
      print(
          'Retry attempt ${errorCount - 1} for ${err.requestOptions.path}: ${err.message}');
    }

    super.onError(err, handler);
  }

  @override
  void onResponse(
    network.Response response,
    network.ResponseInterceptorHandler handler,
  ) {
    final requestKey =
        '${response.requestOptions.method}_${response.requestOptions.path}_${response.requestOptions.hashCode}';
    _errorCounts.remove(requestKey);

    super.onResponse(response, handler);
  }

  bool _isRetryableError(network.DioException error) {
    return error.type == network.DioExceptionType.connectionTimeout ||
        error.type == network.DioExceptionType.receiveTimeout ||
        error.type == network.DioExceptionType.sendTimeout ||
        error.type == network.DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            [500, 502, 503, 504].contains(error.response!.statusCode));
  }

  bool _shouldSkipAlert() {
    return Get.currentRoute.contains("otr");
  }
}
