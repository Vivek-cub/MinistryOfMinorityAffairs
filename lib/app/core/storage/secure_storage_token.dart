
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ministry_of_minority_affairs/app/core/network/token_storage.dart';

class SecureTokenStorage implements TokenStorage{
  static const _keyAccessToken="access_token";
  static const _keyRefreshToken="refresh_token";
  static const _keySessionId="session_id";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<String?> getAccessToken() async{
    return await _secureStorage.read(key: _keyAccessToken);
  }

  @override
  Future<void> saveAccessToken(String token) async{
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async{
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async{
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  @override
  Future<String?> getSessionId() async{
    await _secureStorage.read(key: _keySessionId);
  }

  @override
  Future<void> saveSessionId(String sid) async{
    await _secureStorage.write(key: _keySessionId, value: sid);
  }


  @override
  Future<void> clearAll() async{
    await _secureStorage.deleteAll();
  }

}