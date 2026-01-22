import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:ministry_of_minority_affairs/app/core/constants/app_constants.dart';
import 'package:ministry_of_minority_affairs/app/services/storage_service.dart';

/// API Service for handling all HTTP requests
/// Centralizes API communication with error handling and authentication
class ApiService extends getx.GetxService {
  late Dio _dio;
  final _storageService = getx.Get.find<StorageService>();

  /// Initialize API service
  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));

    return this;
  }

  /// Request interceptor - Add auth token
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    print('🌐 API Request: ${options.method} ${options.path}');
    handler.next(options);
  }

  /// Response interceptor - Log response
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  /// Error interceptor - Handle errors
  Future<void> _onError(DioException error, ErrorInterceptorHandler handler) async {
    print('❌ API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
    
    // Handle specific error codes
    switch (error.response?.statusCode) {
      case 401:
        // Unauthorized - Token expired or invalid
        _storageService.logout();
        getx.Get.snackbar('Session Expired', 'Please login again');
        // Navigate to login
        // Get.offAllNamed(AppRoutes.login);
        break;
      case 403:
        getx.Get.snackbar('Access Denied', 'You do not have permission');
        break;
      case 404:
        getx.Get.snackbar('Not Found', 'The requested resource was not found');
        break;
      case 500:
        getx.Get.snackbar('Server Error', 'Something went wrong on the server');
        break;
      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          getx.Get.snackbar('Timeout', AppConstants.errorTimeout);
        } else if (error.type == DioExceptionType.connectionError) {
          getx.Get.snackbar('Network Error', AppConstants.errorNetwork);
        } else {
          getx.Get.snackbar('Error', error.message ?? AppConstants.errorGeneric);
        }
    }
    
    handler.next(error);
  }

  // ==================== HTTP Methods ====================

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Upload file
  Future<Response> uploadFile(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }
}
