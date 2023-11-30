import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hellocryptography/app/core/exceptions/secure_storage_exception.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<void> addKeys(String values, String key) async {
    try {
      String? value = await _storage.read(key: key);
      if (value == null) {
        await _storage.write(key: key, value: values);
      }
      await _storage.delete(key: key);
      await _storage.write(key: key, value: values);
    } catch (e, s) {
      log("Houve um Problema inesperado com o storage",
          error: e, stackTrace: s);
      throw SecureStorageException(
          "Houve um Problema inesperado com o storage");
    }
  }

  Future<String?> readKeys(String key) async {
    try {
      String? values = await _storage.read(key: key);
      if (values == null) {
        return values;
      } else {
        log(values);
        return values;
      }
    } catch (e, s) {
      log("Houve um problema inesperado com a leitura do storage",
          error: e, stackTrace: s);
      throw SecureStorageException(
          "Houve um problema inesperado com a leitura do storage");
    }
  }
}
