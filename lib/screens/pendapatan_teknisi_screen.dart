import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';

class PendapatanTeknisiScreen extends StatefulWidget {
  const PendapatanTeknisiScreen({super.key});

  @override
  State<PendapatanTeknisiScreen> createState() => _PendapatanTeknisiScreenState();
}

class _PendapatanTeknisiScreenState extends State<PendapatanTeknisiScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // Format Rupiah
  String formatRupiah(dynamic value) {
    final formatter = NumberFormat.decimalPattern('id');
    return formatter.format(int.parse(value.toString().split('.')[0]));
  }

  // Fetch data
  Future<List<dynamic>> fetchPendapatan() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("${AppConfig.baseUrl}/pekerjaan/riwayat"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Filter bulan & tahun
  List<dynamic> filterData(List<dynamic> jobs) {
    return jobs.where((job) {
      DateTime date = DateTime.parse(job['jadwal_service']);
      return date.month == selectedMonth && date.year == selectedYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Pendapatan",
          style: TextStyle(
            color: Color(0xFF1A1AFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: fetchPendapatan(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List jobs = filterData(snapshot.data!);

          int totalPendapatan = jobs.fold(
            0,
            (sum, job) => sum + double.parse(job['total_harga'].toString()).toInt(),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // =============================
                // CARD TOTAL PENDAPATAN
                // =============================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1AFF), Color(0xFF3366FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Pendapatan",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Rp ${formatRupiah(totalPendapatan)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Pendapatan Bulan Ini",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =============================
                // FILTER BULAN & TAHUN
                // =============================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Filter Bulan
                      Expanded(
                        child: _buildDropdown(
                          value: selectedMonth,
                          items: List.generate(12, (i) => i + 1),
                          labelBuilder: (v) => DateFormat.MMMM().format(DateTime(0, v)),
                          onChanged: (v) => setState(() => selectedMonth = v!),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Expanded(
                      child: _buildDropdown(
                        value: selectedYear,
                        items: ([
                          ...List.generate(5, (i) => DateTime.now().year - i),
                          ...List.generate(6, (i) => DateTime.now().year + i),
                        ].toSet().toList()..sort()),
                        labelBuilder: (v) => v.toString(),
                        onChanged: (v) => setState(() => selectedYear = v!),
                      ),
                    ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // =============================
                // RIWAYAT
                // =============================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Riwayat Pendapatan",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (jobs.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Tidak ada data untuk bulan ini",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...jobs.map((job) {
                          return _buildTransactionItem(
                            job['layanan']['jenis_layanan'],
                            job['jadwal_service'].substring(0, 10),
                            "Rp ${formatRupiah(job['total_harga'])}",
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================
  // DROPDOWN CUSTOM
  // ================
  Widget _buildDropdown({
    required int value,
    required List<int> items,
    required String Function(int) labelBuilder,
    required Function(int?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButton<int>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
        ),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(labelBuilder(e)),
                ))
            .toList(),
      ),
    );
  }

  // ====================
  // RIWAYAT ITEM
  // ====================
  Widget _buildTransactionItem(String service, String date, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1AFF).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, color: Color(0xFF1A1AFF), size: 20),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF059669),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Lunas",
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
