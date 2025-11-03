import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';

class RiwayatPemesananScreen extends StatefulWidget {
  const RiwayatPemesananScreen({super.key});

  @override
  State<RiwayatPemesananScreen> createState() => _RiwayatPemesananScreenState();
}

class _RiwayatPemesananScreenState extends State<RiwayatPemesananScreen> {
  final Color primaryBlue = const Color(0xFF1A1AFF);
  
  bool _isLoading = true;
  List<dynamic> _orders = [];

  // 🔧 Pastikan sesuai IP server Laravel kamu
  final String baseUrl = '${AppConfig.baseUrl}/riwayat-pemesanan';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '-';
    // format: 15 Okt 2025, 11:00
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(parsed.toLocal());
  }

  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint("Token tidak ditemukan");
        setState(() => _isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _orders = data['data'] ?? [];
          _isLoading = false;
        });
      } else {
        debugPrint("Error: ${response.body}");
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat riwayat pemesanan')),
        );
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      setState(() => _isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diproses':
        return primaryBlue;
      case 'Dikerjakan':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('Belum ada riwayat pemesanan'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final layanan = order['layanan']?['jenis_layanan'] ?? 'Tidak ada';
                      final teknisi = order['teknisi']?['nama'] ?? 'Belum ditugaskan';
                      final total = double.tryParse(order['total_harga'].toString()) ?? 0.0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _riwayatCard(
                          tanggalPesan: formatDate(order['tanggal_pemesanan']),
                          jadwalService: formatDate(order['jadwal_service']),
                          status: order['status'] ?? '-',
                          totalHarga: total,
                          layanan: layanan,
                          teknisi: teknisi,
                          statusColor: _getStatusColor(order['status'] ?? ''),
                        ),
                      );
                    },
                  ),
                ),

    );
  }

  Widget _riwayatCard({
    required String tanggalPesan,
    required String jadwalService,
    required String status,
    required double totalHarga,
    required String layanan,
    required String teknisi,
    required Color statusColor,
  }) {
    final formatCurrency = NumberFormat('#,###', 'id_ID');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Layanan: $layanan', style: const TextStyle(fontSize: 12)),
              Text('Teknisi: $teknisi', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text('Dipesan: $tanggalPesan', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Jadwal: $jadwalService', style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          // Kanan
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total: Rp ${formatCurrency.format(totalHarga)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
