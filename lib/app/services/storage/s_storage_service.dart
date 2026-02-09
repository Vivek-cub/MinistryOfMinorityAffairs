import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum SStorageKeys {
  token,
  userId,
  mobilePin,

}

class SStorageService extends GetxService {
  late final FlutterSecureStorage _storage;

  @override
  void onInit() {
    _storage = FlutterSecureStorage(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      ),
      iOptions: const IOSOptions(),
    );
    super.onInit();
  }

  Future<String?> readKey({
    required SStorageKeys key,
  }) async =>
      await _storage.read(
        key: key.toString(),
      );

  Future<Map<String, String>> get allValues async => await _storage.readAll();

  Future<void> deleteKey(SStorageKeys key) async => await _storage.delete(
        key: key.toString(),
      );
  Future<void> deleteAll() async => await _storage.deleteAll();

  Future<void> writeKey({
    required SStorageKeys key,
    required String value,
  }) async =>
      await _storage.write(
        key: key.toString(),
        value: value,
      );
}
