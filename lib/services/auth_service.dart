import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';

class AuthService {
  // 🔸 Base URL backend Laravel
  static const String baseUrl = AppConfig.baseUrl;

  // 📝 REGISTER CUSTOMER
  static Future<Map<String, dynamic>> register({
    required String name,
    required String alamat,
    required String noHp,
    required String gender,
    required String email,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          "name": name,
          "alamat": alamat,
          "no_hp": noHp,
          "gender": gender,
          "email": email,
          "username": username,
          "password": password,
        },
      );

      print("🔹 Register Status code: ${response.statusCode}");
      print("🔸 Register Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Respons server bukan JSON. Cek route Laravel atau URL.'};
      }
    } catch (e) {
      print("❌ Error saat register: $e");
      return {'message': 'Gagal terhubung ke server. Pastikan backend jalan & IP benar.'};
    }
  }

  // 📝 LOGIN
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {"username": username, "password": password},
      );

      print("🔹 Login Status code: ${response.statusCode}");
      print("🔸 Login Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
        }
        return data;
      } else {
        return {'message': 'Respons server bukan JSON. Periksa URL API.'};
      }
    } catch (e) {
      print("❌ Error saat login: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // 📝 AMBIL PROFILE USER
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/profile");

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      print("🔹 Profile Status code: ${response.statusCode}");
      print("🔸 Profile Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
        return {'message': data['message'] ?? 'Data profil tidak ditemukan'};
      } else {
        return {'message': 'Respons server bukan JSON. Periksa route /profile.'};
      }
    } catch (e) {
      print("❌ Error saat ambil profil: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // 📝 UPDATE PROFILE USER
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String alamat,
    required String noHp,
    required String gender,
    required String email,
  }) async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/profile/update");

    try {
      final response = await http.put(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        body: {
          "name": name,
          "alamat": alamat,
          "no_hp": noHp,
          "gender": gender,
          "email": email,
        },
      );

      print("🔹 Update Profile Status code: ${response.statusCode}");
      print("🔸 Update Profile Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Respons server bukan JSON. Periksa route /profile/update.'};
      }
    } catch (e) {
      print("❌ Error saat update profil: $e");
      return {'success': false, 'message': 'Gagal terhubung ke server.'};
    }
  }

  // 📝 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // 📝 AMBIL TOKEN TERSIMPAN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // 🧰 REGISTER TEKNISI
  static Future<Map<String, dynamic>> registerAsTechnician({
  required String nama,
  required String alamat,
  required String telepon,
  required String keahlian,
  required String pengalaman,
  String? sertifikat,
}) async {
  final token = await getToken();
  final url = Uri.parse("$baseUrl/teknisi/register");

  try {
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {
        "alamat": alamat,
        "telepon": telepon,
        "keahlian": keahlian,
        "pengalaman": pengalaman,
        if (sertifikat != null) "sertifikat": sertifikat,
      },
    );

    print("🔹 Teknisi Register Status code: ${response.statusCode}");
    print("🔸 Teknisi Register Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "message": "Pendaftaran teknisi berhasil", "data": jsonDecode(response.body)};
    } else {
      return {"success": false, "message": jsonDecode(response.body)['message'] ?? "Gagal daftar teknisi"};
    }
  } catch (e) {
    return {"success": false, "message": "Terjadi kesalahan: $e"};
  }
}
}