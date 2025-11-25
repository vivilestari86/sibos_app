import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sibos_app/screens/profil_screen.dart';
import 'package:sibos_app/screens/teknisi_form_screen.dart';
import 'package:sibos_app/screens/search_screen.dart';
import 'package:sibos_app/screens/service_detail_screen.dart';
import 'package:sibos_app/services/layanan_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  late final List<Widget> _pages = [
    _berandaTab(),
    const SearchScreen(),
    const TeknisiFormScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF1A1AFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pencarian"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Daftar Teknisi"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // =======================
  // Tab Beranda
  // =======================
  Widget _berandaTab() {
    return FutureBuilder<List<dynamic>>(
      future: LayananService.fetchLayanan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
        }

        final layanans = snapshot.data ?? [];

        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1AFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.home, color: Colors.white, size: 30),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/notifications");
                                },
                                child: const Icon(Icons.notifications, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => _logout(context),
                                child: const Icon(Icons.logout, color: Colors.white, size: 28),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              "Selamat Datang\ndi Layanan Service Rumah Tangga",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Nikmati layanan kami sesuai kebutuhan anda",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Grid layanan
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: layanans.isEmpty
                    ? const Center(child: Text("Tidak ada layanan tersedia"))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: layanans.length,
                        itemBuilder: (context, index) {
                          final layanan = layanans.elementAt(index);
                          return _serviceCard(
                            context: context,
                            id: layanan['id'],
                            title: layanan['jenis_layanan'] ?? '-',
                            imagePath: layanan['gambar'] ?? 'assets/images/default.jpg',
                            description: layanan['deskripsi'] ?? '',
                            harga: layanan['harga'] ?? 0,
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =======================
  // Widget Card Layanan
  // =======================
  Widget _serviceCard({
    required BuildContext context,
    required int id,
    required String title,
    required String imagePath,
    required String description,
    required int harga,
  }) {
    //Hasil Refactoring
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imagePath.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
              errorWidget: (c, s, e) =>
                  Image.asset('assets/images/default.jpg', fit: BoxFit.cover),
            )
          : Image.asset(imagePath, fit: BoxFit.cover),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(
              serviceId: id,
              title: title,
              imagePath: imagePath,
              description: description,
              harga: harga,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: imageWidget),
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
