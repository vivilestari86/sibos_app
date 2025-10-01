import 'package:flutter/material.dart';

class TeknisiHomeScreen extends StatefulWidget {
  const TeknisiHomeScreen({super.key});

  @override
  State<TeknisiHomeScreen> createState() => _TeknisiHomeScreenState();
}

class _TeknisiHomeScreenState extends State<TeknisiHomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman tab bawah
  final List<Widget> _pages = [
    const Center(child: Text("Beranda Teknisi")),
    const PekerjaanTab(),
    const Center(child: Text("Pendapatan Teknisi")),
    const Center(child: Text("Profil Teknisi")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ================= HEADER =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1AFF),
        title: const Text(
          "Halaman Teknisi",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // bisa arahkan ke halaman notifikasi teknisi
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Aksi logout
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: _pages[_selectedIndex],

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A1AFF),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Pekerjaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Pendapatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ==================== Tab Pekerjaan ====================
class PekerjaanTab extends StatelessWidget {
  const PekerjaanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Pekerjaan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1AFF),
            ),
          ),
          const SizedBox(height: 20),
          _buildPekerjaanCard("3", "Pekerjaan baru"),
          _buildPekerjaanCard("2", "Sedang dikerjakan"),
          _buildPekerjaanCard("4", "Selesai"),
        ],
      ),
    );
  }

  Widget _buildPekerjaanCard(String count, String title) {
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
              Text(title),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1AFF),
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text("Selengkapnya"),
          ),
        ],
      ),
    );
  }
}
