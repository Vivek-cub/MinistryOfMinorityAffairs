import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/model/verify_mobile_otp_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

class AuthService extends GetxService {
  final SStorageService storage;

  AuthService(this.storage);

  final RxBool _loggedIn = false.obs;
  final RxnString _token = RxnString();
  final RxnString _userId = RxnString();
  final RxnString _fcmToken = RxnString();
  final RxnString _userRole = RxnString();
  final RxnString _pin = RxnString();
  final RxBool _isPinSet = false.obs;
  final RxBool _isPinVerifiedForSession = false.obs;

  @override
  void onInit() {
    isLoggedIn();
    loadPinState();
    super.onInit();
  }

  //AUTH

  Future<bool> isLoggedIn() async {
    final value = await storage.readKey(key: SStorageKeys.token);
    final isValid = value != null && value.isNotEmpty;

    _token(value);
    _loggedIn(isValid);
    return isValid;
  }

  bool get loggedIn => _loggedIn.value;
  String? get getToken => _token.value;

  Future<bool> onLogin(String? tokenValue) async {
    if (tokenValue == null) return false;

    await storage.writeKey(key: SStorageKeys.token, value: tokenValue);
    _token(tokenValue);
    _loggedIn(true);
    return true;
  }

  Future<bool> onLogout() async {
    final userToken = await getUserToken();
    if (userToken != null && userToken.isNotEmpty) {
      if (Get.isRegistered<SubmissionRepository>()) {
        await Get.find<SubmissionRepository>().clearLocalDataForUser(userToken);
      }
      if (Get.isRegistered<ProjectRepository>()) {
        await Get.find<ProjectRepository>().clearLocalDataForUser(userToken);
      }
    }

    await storage.deleteKey(SStorageKeys.token);
    await storage.deleteKey(SStorageKeys.userId);
    await storage.deleteKey(SStorageKeys.userRole);

    _loggedIn(false);
    _token(null);
    _userRole(null);
    _isPinVerifiedForSession(false);
    return true;
  }

  Future<void> clearPin() async {
    await storage.deleteKey(SStorageKeys.mobilePin);
    _pin(null);
    _isPinSet(false);
    _isPinVerifiedForSession(false);
  }

  //PIN

  Future<void> loadPinState() async {
    final value = await storage.readKey(key: SStorageKeys.mobilePin);

    if (value != null && value.isNotEmpty) {
      _pin(value);
      _isPinSet(true);
    } else {
      _pin(null);
      _isPinSet(false);
    }
  }

  bool get isPinSet => _isPinSet.value;
  bool get isPinVerifiedForSession => _isPinVerifiedForSession.value;

  void markPinVerifiedForSession() {
    _isPinVerifiedForSession(true);
  }

  Future<bool> setPin(String pin) async {
    await storage.writeKey(key: SStorageKeys.mobilePin, value: pin);

    _pin(pin);
    _isPinSet(true);
    return true;
  }

  Future<void> setUserId(String userId) async {
    await storage.writeKey(key: SStorageKeys.userId, value: userId);
    _userId(userId);
  }

  Future<void> setFcmToken(String fcmToken) async {
    await storage.writeKey(key: SStorageKeys.fcmToken, value: fcmToken);
    _fcmToken(fcmToken);
  }

  Future<void> setUserRole(String role) async {
    await storage.writeKey(key: SStorageKeys.userRole, value: role);
    _userRole(role);
  }

  Future<bool> isPinMatched(String pin) async {
    final value = await storage.readKey(key: SStorageKeys.mobilePin);
    return value != null && value == pin;
  }

  Future<bool> checkPinFromStorage() async {
    final value = await storage.readKey(key: SStorageKeys.mobilePin);
    return value != null && value.isNotEmpty;
  }

  //USER

  Future<String?> getUserToken() async =>
      storage.readKey(key: SStorageKeys.token);
  Future<String?> getFcmToken() async =>
      storage.readKey(key: SStorageKeys.fcmToken);

  Future<String?> getUserId() async =>
      storage.readKey(key: SStorageKeys.userId);

  Future<String?> getUserRole() async {
    final role = _userRole.value;
    if (role != null && role.isNotEmpty) {
      return role;
    }

    final value = await storage.readKey(key: SStorageKeys.userRole);
    _userRole(value);
    return value;
  }

  Future<bool> isStateOfficer() async {
    final role = await getUserRole();
    return _normalizeRole(role) == 'stateofficer';
  }

  Future<bool> isDistrictOfficer() async {
    final role = await getUserRole();
    return _normalizeRole(role) == 'districtofficer';
  }

  Future<String> dashboardRoute() async {
    final stateOfficer = await isStateOfficer();
    final districtOfficer = await isDistrictOfficer();
    return stateOfficer || districtOfficer
        ? AppRoutes.stateDashboard
        : AppRoutes.home;
  }

  String _normalizeRole(String? role) =>
      (role ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
}
