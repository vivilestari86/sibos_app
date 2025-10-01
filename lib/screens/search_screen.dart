import 'package:flutter/material.dart';
import 'service_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _services = [
    {
      "title": "Service Kulkas",
      "image": "assets/images/service_kulkas.jpg",
      "description":
          "Kami menyediakan layanan service kulkas profesional untuk memperbaiki berbagai masalah pada kulkas Anda.\n\n"
          "Keunggulan Layanan Kami:\n"
          "- Teknisi berpengalaman dan terlatih\n"
          "- Harga terjangkau\n"
          "- Layanan cepat dan responsif\n\n"
          "Proses Pengerjaan:\n"
          "- Pemeriksaan awal untuk mengetahui masalah pada kulkas\n"
          "- Perbaikan atau penggantian suku cadang yang rusak\n"
          "- Pengujian kulkas untuk memastikan kinerja optimal",
    },
    {
      "title": "Service AC",
      "image": "assets/images/service_AC.jpg",
      "description":
          "Layanan service AC profesional untuk menjaga performa dan kenyamanan ruangan Anda.\n\n"
          "Keunggulan Layanan Kami:\n"
          "- Teknisi bersertifikat dan berpengalaman\n"
          "- Harga terjangkau\n"
          "- Layanan cepat dan responsif\n\n"
          "Proses Pengerjaan:\n"
          "- Pemeriksaan unit AC untuk mengetahui masalah\n"
          "- Pembersihan atau perbaikan komponen yang bermasalah\n"
          "- Pengujian AC untuk memastikan pendinginan optimal",
    },
    {
      "title": "Service Mesin Cuci",
      "image": "assets/images/service_mesin_cuci.jpg",
      "description":
          "Perbaikan dan maintenance mesin cuci dengan layanan profesional.\n\n"
          "Keunggulan Layanan Kami:\n"
          "- Teknisi berpengalaman\n"
          "- Harga terjangkau\n"
          "- Layanan cepat dan responsif\n\n"
          "Proses Pengerjaan:\n"
          "- Pemeriksaan mesin cuci untuk mendeteksi kerusakan\n"
          "- Perbaikan atau penggantian suku cadang\n"
          "- Pengujian mesin cuci untuk memastikan berfungsi optimal",
    },
    {
      "title": "Cleaning Service Harian",
      "image": "assets/images/cleaning_service_harian.jpg",
      "description":
          "Layanan cleaning service harian untuk rumah, kantor, atau apartemen.\n\n"
          "Keunggulan Layanan Kami:\n"
          "- Tenaga profesional dan terpercaya\n"
          "- Harga terjangkau\n"
          "- Layanan cepat dan sesuai jadwal\n\n"
          "Proses Pengerjaan:\n"
          "- Pembersihan area sesuai kebutuhan\n"
          "- Penggunaan alat dan bahan yang aman\n"
          "- Pemeriksaan akhir untuk memastikan kebersihan maksimal",
    },
  ];

  List<Map<String, String>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _filteredServices = _services;
  }

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredServices = _services;
      } else {
        _filteredServices = _services
            .where((service) =>
                service["title"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1AFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // 👉 NOTIFIKASI DIHAPUS, tinggal icon home aja
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.home, color: Colors.white, size: 30),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Selamat Datang\ndi Layanan Service Rumah Tangga",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Nikmati layanan kami sesuai kebutuhan anda",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterServices,
              decoration: InputDecoration(
                hintText: "Cari Layanan",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterServices("");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Grid hasil pencarian
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _filteredServices.isEmpty
                  ? const Center(child: Text("Layanan tidak ditemukan"))
                  : GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: _filteredServices
                          .map((service) => _serviceCard(
                                context,
                                service["title"]!,
                                service["image"]!,
                                service["description"]!,
                              ))
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _serviceCard(
      BuildContext context, String title, String imagePath, String description) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(
              title: title,
              imagePath: imagePath,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF1A1AFF),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
