import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String baseUrl = "http://192.168.1.8:8000/api";
  static const String imageBaseUrl = "http://192.168.1.8:8000/storage";

  static String token = "";

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }

  static Future<void> saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newToken);
    token = newToken;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = "";
  }
}
