import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

class SimChangeService extends GetxService {
  static const MethodChannel _channel = MethodChannel('app.sim_info');

  final SStorageService storage;

  SimChangeService(this.storage);

  Future<bool> hasSimChanged() async {
    final currentFingerprint = await _getCurrentFingerprint();
    if (currentFingerprint == null || currentFingerprint.isEmpty) {
      return false;
    }

    final savedFingerprint = await storage.readKey(
      key: SStorageKeys.simFingerprint,
    );

    if (savedFingerprint == null || savedFingerprint.isEmpty) {
      await _saveCurrentFingerprint(currentFingerprint);
      return false;
    }

    return savedFingerprint != currentFingerprint;
  }

  Future<bool> hasSimAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasSimAvailable');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> storeCurrentAsBaseline() async {
    final currentFingerprint = await _getCurrentFingerprint();
    if (currentFingerprint == null || currentFingerprint.isEmpty) return;
    await _saveCurrentFingerprint(currentFingerprint);
  }

  Future<String?> _getCurrentFingerprint() async {
    try {
      final result = await _channel.invokeMethod<String>('getSimFingerprint');
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCurrentFingerprint(String fingerprint) async {
    await storage.writeKey(
      key: SStorageKeys.simFingerprint,
      value: fingerprint,
    );
  }
}
