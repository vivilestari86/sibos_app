import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';

class AuthService {
  static const String baseUrl = AppConfig.baseUrl;

  // ===============================
  // REGISTER CUSTOMER
  // ===============================
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

      print("🔹 Register Status: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      }
      return {'message': 'Respons server bukan JSON.'};
    } catch (e) {
      print("❌ Error Register: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // ===============================
  // LOGIN CUSTOMER/TEKNISI
  // ===============================
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          "username": username,
          "password": password,
        },
      );

      print("🔹 Login Status: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);

        // Token format backend kamu: data['data']['token']
        if (response.statusCode == 200 &&
    data['data'] != null &&
    data['data']['token'] != null) 
{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', data['data']['token']);

  // SIMPAN USER ID
  if (data['data']['user'] != null) {
    await prefs.setInt('user_id', data['data']['user']['id']);
  }

  // SIMPAN TEKNISI ID (PALING PENTING)
  if (data['data']['teknisi'] != null) {
    await prefs.setInt('teknisi_id', data['data']['teknisi']['id']);
  }
}


        return data;
      }
      return {'message': 'Respons server bukan JSON.'};
    } catch (e) {
      print("❌ Error Login: $e");
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // ===============================
  // GET PROFILE
  // ===============================
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print("🔹 Profile Status: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
        return {'message': data['message'] ?? 'Profil tidak ditemukan'};
      }

      return {'message': 'Respons server bukan JSON.'};
    } catch (e) {
      return {'message': 'Gagal terhubung ke server.'};
    }
  }

  // ===============================
  // UPDATE PROFILE
  // ===============================
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
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          "name": name,
          "alamat": alamat,
          "no_hp": noHp,
          "gender": gender,
          "email": email,
        },
      );

      print("🔹 Update Status: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.headers['content-type']?.contains('application/json') == true) {
        return jsonDecode(response.body);
      }
      return {'message': 'Respons bukan JSON'};
    } catch (e) {
      return {'message': 'Gagal menghubungi server'};
    }
  }

  // ===============================
  // LOGOUT
  // ===============================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ===============================
  // REGISTER TEKNISI
  // ===============================
static Future<Map<String, dynamic>> registerAsTechnician({
  required String keahlian,
  required String pengalaman,
  required File sertifikatFile,
}) async {
  try {
    final token = await getToken();
    var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/teknisi/register"));
    request.headers['Authorization'] = "Bearer $token";
    request.fields['keahlian'] = keahlian;
    request.fields['pengalaman'] = pengalaman;
    request.files.add(await http.MultipartFile.fromPath("sertifikat", sertifikatFile.path));

    var response = await request.send();
    var body = await response.stream.bytesToString();
    return jsonDecode(body);
  } catch (e) {
    return {'status': 'error', 'message': e.toString()};
  }
}

static Future<Map<String, dynamic>> checkTeknisiStatus() async {
  final token = await getToken();

  if (token == null || token.isEmpty) {
    return {'status': 'none'};
  }

  try {
    final response = await http.get(
      Uri.parse("$baseUrl/teknisi/status"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print("🔹 Status Teknisi Code: ${response.statusCode}");
    print("🔸 Body: ${response.body}");
    print("🔸 Content-Type: ${response.headers['content-type']}");

    if (response.statusCode != 200 ||
        !response.headers['content-type']!.contains("application/json")) {
      return {'status': 'none'};
    }

    final result = jsonDecode(response.body);

    // Kalau backend mengembalikan status "registered" dan data teknisi
    if (result['status'] == 'registered' && result['data'] != null) {
  final teknisiId = result['data']['id'];

  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('teknisi_id', teknisiId);

  print("✔️ TEKNISI ID DISIMPAN: $teknisiId");

  return {
    'status': 'registered',
    'data': result['data'],
  };
}


    return {'status': 'none'};
  } catch (e) {
    print("❌ Error Check Status: $e");
    return {'status': 'none'};
  }
}


  static Future<Map<String, dynamic>> getProfileTeknisi() async {
  final token = await getToken();

  try {
    final response = await http.get(
      Uri.parse("$baseUrl/teknisi/profile"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print("🔹 GetProfileTeknisi Status: ${response.statusCode}");
    print("🔸 Body: ${response.body}");

    if (response.statusCode == 200 &&
        response.headers['content-type']!.contains("application/json")) 
    {
      final data = jsonDecode(response.body);

      // SESUAI DENGAN API LARAVEL
      if (data["success"] == true && data["data"] != null) {
        return data["data"];
      }

      return {"message": data["message"] ?? "Data teknisi tidak ditemukan"};
    }

    return {"message": "Gagal memuat profil teknisi"};
  } catch (e) {
    return {"message": "Gagal terhubung ke server"};
  }
}


  static Future<Map<String, dynamic>> updateProfileTeknisi(
  Map<String, dynamic> data, {
  File? file,
  }) async {
    final token = await getToken();
    final url = Uri.parse("$baseUrl/teknisi/update-profile");

    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath("sertifikat", file.path),
      );
    }

    var res = await request.send();
    var finalRes = await http.Response.fromStream(res);

    return jsonDecode(finalRes.body);
  }
}
