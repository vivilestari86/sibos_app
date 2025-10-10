import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 🔸 Ganti IP sesuai server Laravel kamu
  static const String baseUrl = "http://10.0.170.119:8000/api";

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
        return {
          'message': 'Respons server bukan JSON. Cek route Laravel atau URL.',
        };
      }
    } catch (e) {
      print("❌ Error saat register: $e");
      return {
        'message': 'Gagal terhubung ke server. Pastikan backend jalan & IP benar.',
      };
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
        headers: {
          'Accept': 'application/json',
        },
        body: {
          "username": username,
          "password": password,
        },
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

  // 🧰 REGISTER TEKNISI (setelah login customer)
  static Future<Map<String, dynamic>> registerAsTechnician({
    required String nama,
    required String alamat,
    required String jenisKelamin,
    required String noTelepon,
    required String keahlian,
  }) async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/teknisi/register");

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
  "nama": nama,
  "alamat": alamat,
  "jenis_kelamin": jenisKelamin,
  "telepon": noTelepon,
  "keahlian": keahlian,
},

      );

      print("🔹 Teknisi Status code: ${response.statusCode}");
      print("🔸 Teknisi Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        return {
          'message': 'Respons server bukan JSON. Periksa route Laravel /teknisi/register.',
        };
      }
    } catch (e) {
      print("❌ Error saat daftar teknisi: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // 📝 Ambil Profil User
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🔹 Profile Status code: ${response.statusCode}");
      print("🔸 Profile Response: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      } else {
        return {'message': 'Respons server bukan JSON. Periksa route /profile.'};
      }
    } catch (e) {
      print("❌ Error saat ambil profil: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // 📝 LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // 📝 Ambil token tersimpan
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
