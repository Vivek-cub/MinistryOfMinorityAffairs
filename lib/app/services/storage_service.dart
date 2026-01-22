import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ministry_of_minority_affairs/app/core/constants/app_constants.dart';

/// Storage service for managing local data storage
/// Wrapper around GetStorage for centralized storage management
class StorageService extends GetxService {
  late final GetStorage _box;

  /// Initialize storage service
  Future<StorageService> init() async {
    _box = GetStorage();
    return this;
  }

  // ==================== Auth ====================
  
  /// Save authentication token
  void saveToken(String token) {
    _box.write(AppConstants.storageKeyToken, token);
  }

  /// Get authentication token
  String? getToken() {
    return _box.read(AppConstants.storageKeyToken);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear authentication token
  void clearToken() {
    _box.remove(AppConstants.storageKeyToken);
  }

  // ==================== User Data ====================
  
  /// Save user data
  void saveUserData(Map<String, dynamic> userData) {
    _box.write(AppConstants.storageKeyUser, userData);
  }

  /// Get user data
  Map<String, dynamic>? getUserData() {
    return _box.read(AppConstants.storageKeyUser);
  }

  /// Clear user data
  void clearUserData() {
    _box.remove(AppConstants.storageKeyUser);
  }

  // ==================== PIN Management ====================
  
  /// Save user PIN
  void savePin(String pin) {
    _box.write('user_pin', pin);
  }

  /// Get saved PIN
  String? getPin() {
    return _box.read('user_pin');
  }

  /// Check if PIN is set
  bool isPinSet() {
    final pin = getPin();
    return pin != null && pin.isNotEmpty;
  }

  /// Verify PIN
  bool verifyPin(String pin) {
    final savedPin = getPin();
    return savedPin == pin;
  }

  /// Clear PIN
  void clearPin() {
    _box.remove('user_pin');
  }

  // ==================== App Settings ====================
  
  /// Save language preference
  void saveLanguage(String languageCode) {
    _box.write(AppConstants.storageKeyLanguage, languageCode);
  }

  /// Get language preference
  String getLanguage() {
    return _box.read(AppConstants.storageKeyLanguage) ?? AppConstants.defaultLanguage;
  }

  /// Save theme mode
  void saveThemeMode(String mode) {
    _box.write(AppConstants.storageKeyTheme, mode);
  }

  /// Get theme mode
  String getThemeMode() {
    return _box.read(AppConstants.storageKeyTheme) ?? 'light';
  }

  /// Check if first time user
  bool isFirstTime() {
    return _box.read(AppConstants.storageKeyFirstTime) ?? true;
  }

  /// Mark as not first time
  void setNotFirstTime() {
    _box.write(AppConstants.storageKeyFirstTime, false);
  }

  // ==================== Generic Storage ====================
  
  /// Write generic data
  void write(String key, dynamic value) {
    _box.write(key, value);
  }

  /// Read generic data
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  /// Remove specific key
  void remove(String key) {
    _box.remove(key);
  }

  /// Check if key exists
  bool hasKey(String key) {
    return _box.hasData(key);
  }

  // ==================== Clear All ====================
  
  /// Clear all stored data
  void clearAll() {
    _box.erase();
  }

  /// Logout - clear auth related data
  void logout() {
    clearToken();
    clearUserData();
  }
}
