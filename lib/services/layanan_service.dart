import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sibos_app/config.dart';

class LayananService {
  // ✅ Gunakan IP dari AppConfig agar konsisten di seluruh aplikasi
  static final String baseUrl = AppConfig.baseUrl;

  static Future<List<dynamic>> fetchLayanan({String? search}) async {
    try {
      final uri = Uri.parse(
        "$baseUrl/layanans${(search != null && search.isNotEmpty) ? '?search=${Uri.encodeQueryComponent(search)}' : ''}",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'] as List<dynamic>;
        }
      }

      return [];
    } catch (e) {
      print("Error fetchLayanan: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchLayananDetail(int id) async {
    try {
      final uri = Uri.parse("$baseUrl/layanans/$id");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) return data['data'];
      }

      return null;
    } catch (e) {
      print("Error fetchLayananDetail: $e");
      return null;
    }
  }
}
