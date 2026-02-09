import 'dart:math';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

class AuthService extends GetxService {
  final SStorageService storage;

  AuthService(this.storage);

  final RxBool _loggedIn = false.obs;
  final RxnString _token = RxnString();
  final RxnString _pin = RxnString();
  final RxBool _isPinSet = false.obs;

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

    await storage.writeKey(
      key: SStorageKeys.token,
      value: tokenValue,
    );

    _token(tokenValue);
    _loggedIn(true);
    return true;
  }

  Future<bool> onLogout() async {
    await storage.deleteKey(SStorageKeys.token);
    await storage.deleteKey(SStorageKeys.userId);

    _loggedIn(false);
    _token(null);
    return true;
  }

  //PIN

  Future<void> loadPinState() async {
    final value = await storage.readKey(
      key: SStorageKeys.mobilePin,
    );

    if (value != null && value.isNotEmpty) {
      _pin(value);
      _isPinSet(true);
    } else {
      _pin(null);
      _isPinSet(false);
    }
  }

  bool get isPinSet => _isPinSet.value;

  Future<bool> setPin(String pin) async {
    await storage.writeKey(
      key: SStorageKeys.mobilePin,
      value: pin,
    );

    _pin(pin);
    _isPinSet(true);
    return true;
  }

  Future<bool> isPinMatched(String pin) async {
    final value = await storage.readKey(
      key: SStorageKeys.mobilePin,
    );
    return value != null && value == pin;
  }

  Future<bool> checkPinFromStorage() async {
  final value = await storage.readKey(
    key: SStorageKeys.mobilePin,
  );
  return value != null && value.isNotEmpty;
}


  //USER

  Future<String?> getUserId() async =>
      storage.readKey(key: SStorageKeys.userId);

}


