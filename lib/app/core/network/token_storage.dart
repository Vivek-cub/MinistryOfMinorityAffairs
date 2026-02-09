
abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);

  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);

  Future<String?> getSessionId();
  Future<void> saveSessionId(String sid);

  Future<void> clearAll();

}