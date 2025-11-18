import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String baseUrl = "http://10.206.138.4:8000/api";
  static const String imageBaseUrl = "http://10.206.138.4:8000/storage";

  // Token kosong default (sementara)
  static String token = "";

  /// Ambil token terbaru dari SharedPreferences (hasil login)
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
  }
}
