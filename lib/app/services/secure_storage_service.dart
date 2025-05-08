import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static Future<void> writeToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> writeUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<String?> readUserId() async {
    return await _storage.read(key: 'user_id');
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
