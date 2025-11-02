import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'user_email';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Save email
  static Future<void> saveEmail(String email) async {
    await _storage.write(key: _emailKey, value: email);
  }

  // Get email
  static Future<String?> getEmail() async {
    return await _storage.read(key: _emailKey);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
