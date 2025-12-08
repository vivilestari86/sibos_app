import 'package:flutter/material.dart';
import 'package:sibos_app/screens/pekerjaan_baru_screen.dart';
import 'package:sibos_app/screens/sedang_dikerjakan_screen.dart';
import 'package:sibos_app/screens/pekerjaan_selesai_screen.dart';
import 'package:sibos_app/screens/pendapatan_teknisi_screen.dart';

class BerandaTeknisiScreen extends StatelessWidget {
  const BerandaTeknisiScreen({super.key, required nama});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟦 Judul Selamat Datang
          const Text(
            "Selamat datang di halaman teknisi",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1AFF),
            ),
          ),

          const SizedBox(height: 20),

          // 📌 Total Pendapatan dipindah ke bawah judul
          _buildSummaryCard(
            context,
            title: "Total Pendapatan",
            count: "Rp 1.500.000",
            targetPage: const PendapatanTeknisiScreen(),
          ),

          const SizedBox(height: 30),

          // 📌 Daftar Pekerjaan
          _buildSummaryCard(
            context,
            title: "Pekerjaan Baru",
            count: "3",
            targetPage: const PekerjaanBaruScreen(),
          ),
          _buildSummaryCard(
            context,
            title: "Sedang Dikerjakan",
            count: "2",
            targetPage: const SedangDikerjakanScreen(),
          ),
          _buildSummaryCard(
            context,
            title: "Selesai",
            count: "4",
            targetPage: const PekerjaanSelesaiScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String count,
    required Widget targetPage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1AFF),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1AFF),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => targetPage),
              );
            },
            child: const Text("Lihat"),
          ),
        ],
      ),
    );
  }
}
