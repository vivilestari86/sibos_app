import 'package:flutter/material.dart';
import 'package:sibos_app/screens/profil_screen.dart';
import 'package:sibos_app/screens/teknisi_form_screen.dart';
import 'search_screen.dart';
import 'service_detail_screen.dart'; 
import 'chat_screen.dart';
// ignore: duplicate_import
import 'profil_screen.dart';

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

  // Daftar halaman/tab
  late final List<Widget> _pages = [
  _berandaTab(), // tab 0: Beranda
  const SearchScreen(), // tab 1: Pencarian
  const TeknisiFormScreen(),  
  const ChatScreen(), // tab 3: Chat
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
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pencarian"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Daftar Teknisi"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // ============================
  // Tab Beranda
  // ============================
  Widget _berandaTab() {
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
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _serviceCard(
              context,
              "Service Kulkas",
              "assets/images/service_kulkas.jpg",
              "Kami menyediakan layanan service kulkas profesional untuk memperbaiki berbagai masalah pada kulkas Anda.\n\n"
              "Keunggulan Layanan Kami:\n"
              "- Teknisi berpengalaman dan terlatih\n"
              "- Harga terjangkau\n"
              "- Layanan cepat dan responsif\n\n"
              "Proses Pengerjaan:\n"
              "- Pemeriksaan awal untuk mengetahui masalah pada kulkas\n"
              "- Perbaikan atau penggantian suku cadang yang rusak\n"
              "- Pengujian kulkas untuk memastikan kinerja optimal",
            ),
            _serviceCard(
              context,
              "Service AC",
              "assets/images/service_AC.jpg",
              "Layanan service AC profesional untuk menjaga performa dan kenyamanan ruangan Anda.\n\n"
              "Keunggulan Layanan Kami:\n"
              "- Teknisi bersertifikat dan berpengalaman\n"
              "- Harga terjangkau\n"
              "- Layanan cepat dan responsif\n\n"
              "Proses Pengerjaan:\n"
              "- Pemeriksaan unit AC untuk mengetahui masalah\n"
              "- Pembersihan atau perbaikan komponen yang bermasalah\n"
              "- Pengujian AC untuk memastikan pendinginan optimal",
            ),
            _serviceCard(
              context,
              "Service Mesin Cuci",
              "assets/images/service_mesin_cuci.jpg",
              "Perbaikan dan maintenance mesin cuci dengan layanan profesional.\n\n"
              "Keunggulan Layanan Kami:\n"
              "- Teknisi berpengalaman\n"
              "- Harga terjangkau\n"
              "- Layanan cepat dan responsif\n\n"
              "Proses Pengerjaan:\n"
              "- Pemeriksaan mesin cuci untuk mendeteksi kerusakan\n"
              "- Perbaikan atau penggantian suku cadang\n"
              "- Pengujian mesin cuci untuk memastikan berfungsi optimal",
            ),
            _serviceCard(
              context,
              "Cleaning Service Harian",
              "assets/images/cleaning_service_harian.jpg",
              "Layanan cleaning service harian untuk rumah, kantor, atau apartemen.\n\n"
              "Keunggulan Layanan Kami:\n"
              "- Tenaga profesional dan terpercaya\n"
              "- Harga terjangkau\n"
              "- Layanan cepat dan sesuai jadwal\n\n"
              "Proses Pengerjaan:\n"
              "- Pembersihan area sesuai kebutuhan\n"
              "- Penggunaan alat dan bahan yang aman\n"
              "- Pemeriksaan akhir untuk memastikan kebersihan maksimal",
            ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================
  // Widget service card dengan onTap
  // ============================
  Widget _serviceCard(
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
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
