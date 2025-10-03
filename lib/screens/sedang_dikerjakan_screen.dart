import 'package:flutter/material.dart';
import 'pekerjaan_selesai_screen.dart';

class SedangDikerjakanScreen extends StatelessWidget {
  const SedangDikerjakanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1AFF),
        title: const Text("Sedang Dikerjakan", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Pekerjaan Sedang Dikerjakan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildCard(context, "16-09-2025"),
            _buildCard(context, "16-09-2025"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Anda ditugaskan untuk service AC pada alamat berikut:"),
          const Text("Nama : "),
          const Text("Alamat : "),
          const Text("No.Hp : "),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PekerjaanSelesaiScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1AFF),
              foregroundColor: Colors.white,
            ),
            child: const Text("Selesai"),
          ),
        ],
      ),
    );
  }
}
