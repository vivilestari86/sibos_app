import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'detail_pemesanan_screen.dart';
import 'package:intl/intl.dart';


class ServiceDetailScreen extends StatelessWidget {
  final int serviceId;          // ✅ Tambahkan ID layanan
  final String title;
  final String description;
  final String imagePath;
  final int harga;              // ✅ Tambahkan harga

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.harga,
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
              // ✅ Gambar layanan
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Nama layanan
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1AFF),
                ),
              ),
              const SizedBox(height: 8),

              // ✅ Harga layanan
              Text(
                                'Harga: Rp ${NumberFormat('#,###', 'id_ID').format(harga)}',
                                  style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
              const SizedBox(height: 12),

              // ✅ Deskripsi layanan
              Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 24),

              // ✅ Tombol Pesan Sekarang
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPemesananScreen(
                          serviceId: serviceId,     // ✅ kirim ID
                          serviceTitle: title,      // ✅ kirim nama
                          imagePath: imagePath,     // ✅ kirim gambar
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
