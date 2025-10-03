import 'package:flutter/material.dart';

class PekerjaanSelesaiScreen extends StatelessWidget {
  const PekerjaanSelesaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1AFF),
        title: const Text("Pekerjaan Selesai", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Pekerjaan Selesai",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1AFF),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard("16-09-2025", "Rp. 220.000"),
            _buildCard("16-09-2025", "Rp. 135.000"),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String date, String income) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAFF), // sama seperti halaman baru & sedang dikerjakan
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1AFF), // tombol biru
              foregroundColor: Colors.white, // teks putih
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text("Hasil Pendapatan $income"),
          ),
        ],
      ),
    );
  }
}
