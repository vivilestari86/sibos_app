import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';
import 'pekerjaan_selesai_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SedangDikerjakanScreen extends StatefulWidget {
  const SedangDikerjakanScreen({super.key});

  @override
  State<SedangDikerjakanScreen> createState() => _SedangDikerjakanScreenState();
}

class _SedangDikerjakanScreenState extends State<SedangDikerjakanScreen> {
  Future<List<dynamic>> fetchSedangDikerjakan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${AppConfig.baseUrl}/pekerjaan/dikerjakan"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Konversi nomor 08 -> 62 (internasional)
  String convertToIntl(String number) {
    String cleaned = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = "62" + cleaned.substring(1);
    }
    return cleaned;
  }

  // Buka WhatsApp dengan pesan otomatis (nama customer + service)
  Future<void> openWhatsApp(String number, String customerName, String serviceName) async {
    String cleaned = convertToIntl(number);

    final String message = Uri.encodeComponent(
      "Halo customer $customerName, saya dari teknisi layanan $serviceName akan menuju ke lokasi anda. "
      "Mohon kirim alamat lengkapnya dan harap ditunggu ya😊🙏"
    );

    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$cleaned&text=$message");
    final Uri webUri = Uri.parse("https://wa.me/$cleaned?text=$message");

    // coba buka aplikasi WhatsApp dulu
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return;
    }

    // fallback ke wa.me
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tidak dapat membuka WhatsApp")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Sedang Dikerjakan",
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
      body: FutureBuilder(
        future: fetchSedangDikerjakan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Tidak ada pekerjaan yang sedang dikerjakan"),
            );
          }

          final jobs = snapshot.data as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA000).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.build_circle, color: Color(0xFFFFA000), size: 32),
                      const SizedBox(height: 12),
                      Text(
                        "${jobs.length} Pekerjaan Aktif",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA000),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // LIST DARI API
                for (var job in jobs)
                  _buildJobCard(
                    context,
                    job['id'],
                    // ambil nama layanan dengan fallback aman
                    job['layanan']?['jenis_layanan'] ??
                        job['layanan']?['nama_layanan'] ??
                        job['layanan']?['layanan'] ??
                        "(Layanan tidak tersedia)",
                    job['user']?['name'] ?? "(User)",
                    job['user']?['alamat'] ?? "-",
                    job['user']?['no_hp'] ?? job['user']?['nohp'] ?? job['user']?['no_hp'] ?? "-",
                    // jadwal may need checking if null
                    job['jadwal_service'] != null && job['jadwal_service'] is String && job['jadwal_service'].length >= 16
                        ? job['jadwal_service'].substring(0, 10)
                        : "-",
                    job['jadwal_service'] != null && job['jadwal_service'] is String && job['jadwal_service'].length >= 16
                        ? job['jadwal_service'].substring(11)
                        : "-",
                  ),
              ],
            ),
          );
        },
      ),
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
                  color: const Color(0xFFFFA000).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Dalam Proses",
                  style: TextStyle(
                    color: Color(0xFFFFA000),
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
          _buildInfoRow(Icons.phone, "Telepon", phone, customerName: customerName, serviceName: service),
          _buildInfoRow(Icons.calendar_today, "Tanggal", date),
          _buildInfoRow(Icons.access_time, "Waktu", time),

          const SizedBox(height: 20),

          // Action Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1A1AFF),
            ),
            child: TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString("token");

                final url = Uri.parse("${AppConfig.baseUrl}/pekerjaan/selesai/$pemesananId");

                final response = await http.post(
                  url,
                  headers: {
                    "Authorization": "Bearer $token",
                    "Accept": "application/json",
                  },
                );

                if (response.statusCode == 200) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PekerjaanSelesaiScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal menandai selesai")),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Tandai Selesai",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    String? customerName,
    String? serviceName,
  }) {
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
                label == "Telepon"
                    ? GestureDetector(
                        onTap: () {
                          openWhatsApp(value, customerName ?? "", serviceName ?? "");
                        },
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
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