import 'package:flutter/material.dart';
import 'detail_pemesanan_screen.dart'; // ✅ pastikan file ini ada

class ServiceDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const ServiceDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1AFF),
        foregroundColor: Colors.white,
        title: const Text("Deskripsi Layanan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1AFF),
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    // ✅ Arahkan ke halaman detail pemesanan
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPemesananScreen(
                          serviceTitle: title,
                          imagePath: imagePath,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Pesan Sekarang",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
