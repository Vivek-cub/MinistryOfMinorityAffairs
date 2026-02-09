
import 'package:dio/dio.dart';

class CurlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final curl = _generateCurl(options);
    print('🧾 cURL:\n$curl');
    handler.next(options);
  }

  String _generateCurl(RequestOptions options) {
    final buffer = StringBuffer();

    buffer.write('curl --location');
    buffer.write(" '${options.uri}'");

    // Method
    if (options.method.toUpperCase() != 'GET') {
      buffer.write(' \\\n  --request ${options.method}');
    }

    // Headers
    options.headers.forEach((key, value) {
      buffer.write(" \\\n  --header '$key: $value'");
    });

    // Data
    final data = options.data;

    if (data is FormData) {
      // Fields
      for (final field in data.fields) {
        buffer.write(" \\\n  --form '${field.key}=${field.value}'");
      }

      // Files
      for (final file in data.files) {
        final filename = file.value.filename ?? 'file';
        buffer.write(
          " \\\n  --form '${file.key}=@\"$filename\"'",
        );
      }
    } else if (data != null) {
      buffer.write(" \\\n  --data '${data.toString()}'");
    }

    return buffer.toString();
  }
}
