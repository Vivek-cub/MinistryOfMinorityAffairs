
import 'package:ministry_of_minority_affairs/app/core/network/token_storage.dart';

import 'enums.dart';

class HeaderBuilder {
  final TokenStorage storage;
  HeaderBuilder(this.storage);

  Future<Map<String, dynamic>> build({
    Map<String, dynamic>? customHeader,
    bool requireSession = true,
    bool requireBearerToken = false,
    HeaderType type = HeaderType.json,
  }) async {
    final Map<String,dynamic> headers={};

    //Content-Type & Accept
    headers.addAll(_baseHeaders(type));

    // Bearer Authorization
    if(requireBearerToken) {
      final token = storage.getAccessToken();
      if(token != null){
        headers['Authorization'] = 'Bearer $token';
      }
    }

    // ERPNext SID Cookie
    if(requireSession){
      final sid = storage.getSessionId();
      if(sid != null){
        headers['Cookie'] = 'sid=$sid; system_user=yes; user_id=Administrator;';
      }
    }

    // Custom Overrides
    if(customHeader != null){
      headers.addAll(customHeader);
    }

    return headers;

  }


Map<String, String> _baseHeaders(HeaderType type){
    switch(type) {
      case HeaderType.formData:
        return {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        };
      case HeaderType.multipart:
        return {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        };
      case HeaderType.xml:
        return {
          'Accept': 'application/xml',
          'Content-Type': 'application/xml',
        };
      default:
        return {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        };
    }
}

}