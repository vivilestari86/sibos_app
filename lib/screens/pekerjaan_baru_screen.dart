import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sibos_app/config.dart';
import 'sedang_dikerjakan_screen.dart';

class PekerjaanBaruScreen extends StatelessWidget {
  const PekerjaanBaruScreen({super.key});

  @override

  Future<List<dynamic>> fetchPekerjaanBaru() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final teknisiId = prefs.getInt('teknisi_id');

  final url = "${AppConfig.baseUrl}/pekerjaan-baru";

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  // Debug print → ditempatkan sebelum return
  print("TEKNISI ID = $teknisiId");
  print("TOKEN = $token");
  print("URL: $url");
  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['data'];
  } else {
    return [];
  }
}

 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Pekerjaan Baru",
          style: TextStyle(
            color: Color(0xFF1A1AFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1AFF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
  future: fetchPekerjaanBaru(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text("Tidak ada pekerjaan baru"),
      );
    }

    final pekerjaanList = snapshot.data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1AFF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.new_releases, color: Color(0xFF1A1AFF), size: 32),
                const SizedBox(height: 12),
                Text(
                  "${pekerjaanList.length} Pekerjaan Baru",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1AFF),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tampilkan job card dari API
          for (var p in pekerjaanList)
  _buildJobCard(
  context,
  p['id'], // 🟢 KIRIM ID PESANAN!
  p['layanan']?['jenis_layanan'] ?? "-",
  p['user']?['name'] ?? "-",
  p['user']?['alamat'] ?? "-",
  p['user']?['no_hp'] ?? "-",
  p['jadwal_service'] != null
      ? p['jadwal_service'].split(" ")[0]
      : "-",
  p['jadwal_service'] != null
      ? p['jadwal_service'].split(" ")[1]
      : "-",
),


        ],
      ),
    );
  },
)
    );
  }

  Widget _buildJobCard(
    BuildContext context,
    int pemesananId,
    String service,
    String customerName,
    String address,
    String phone,
    String date,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan service dan status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Baru",
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Customer
          _buildInfoRow(Icons.person, "Customer", customerName),
          _buildInfoRow(Icons.location_on, "Alamat", address),
          _buildInfoRow(Icons.phone, "Telepon", phone),
          _buildInfoRow(Icons.calendar_today, "Tanggal", date),
          _buildInfoRow(Icons.access_time, "Waktu", time),
          
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
  child: OutlinedButton(
    onPressed: () async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  final response = await http.post(
    Uri.parse("${AppConfig.baseUrl}/pekerjaan/tolak"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    body: {
      "pemesanan_id": pemesananId.toString(),
    },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pekerjaan ditolak!")),
    );

    Navigator.pop(context);
      } else {
        print("Error: ${response.body}");
      }
    },
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      side: const BorderSide(color: Color(0xFFEF4444)),
    ),
    child: const Text(
      "Tolak",
      style: TextStyle(
        color: Color(0xFFEF4444),
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF1A1AFF),
                  ),
                  child: TextButton(
                    onPressed: () async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  final response = await http.post(
    Uri.parse("${AppConfig.baseUrl}/pekerjaan/terima"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
    body: {
      "pemesanan_id": pemesananId.toString(),
    },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pekerjaan berhasil diterima!")),
    );

    // pindah ke halaman sedang dikerjakan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SedangDikerjakanScreen()),
    );
  } else {
    print("ERROR: ${response.body}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal menerima pekerjaan")),
    );
  }
},

                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Terima",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}