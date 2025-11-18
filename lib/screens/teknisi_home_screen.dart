import 'package:flutter/material.dart';
import 'package:sibos_app/screens/pendapatan_teknisi_screen.dart';
import 'package:sibos_app/screens/profile_teknisi_screen.dart';
import 'package:sibos_app/screens/pekerjaan_baru_screen.dart';
import 'package:sibos_app/screens/sedang_dikerjakan_screen.dart';
import 'package:sibos_app/screens/pekerjaan_selesai_screen.dart';
import 'package:sibos_app/screens/beranda_teknisi_screen.dart';

class TeknisiHomeScreen extends StatefulWidget {
  const TeknisiHomeScreen({super.key});

  @override
  State<TeknisiHomeScreen> createState() => _TeknisiHomeScreenState();
}

class _TeknisiHomeScreenState extends State<TeknisiHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaTeknisiScreen(),
    const PekerjaanTab(),
    const PendapatanTeknisiScreen(),
    const ProfileTeknisiScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk WhatsApp
  void _launchWhatsApp() {
    // TODO: Implement WhatsApp API
    // Contoh: launch('https://wa.me/6281234567890?text=Halo,%20saya%20membutuhkan%20bantuan');
    print('WhatsApp button pressed');
  }

  // Fungsi untuk logout
  void _logout() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Dashboard Teknisi",
          style: TextStyle(
            color: Color(0xFF1A1AFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          // Tombol WhatsApp
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chat, color: Colors.white, size: 20),
            ),
            onPressed: _launchWhatsApp,
          ),
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 22),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A1AFF),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.home_outlined,
                  size: 24,
                  color: _selectedIndex == 0 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home_filled, color: Color(0xFF1A1AFF), size: 24),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.work_outline,
                  size: 24,
                  color: _selectedIndex == 1 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work, color: Color(0xFF1A1AFF), size: 24),
              ),
              label: 'Pekerjaan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.attach_money_outlined,
                  size: 24,
                  color: _selectedIndex == 2 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.attach_money, color: Color(0xFF1A1AFF), size: 24),
              ),
              label: 'Pendapatan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.person_outline,
                  size: 24,
                  color: _selectedIndex == 3 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF1A1AFF), size: 24),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class PekerjaanTab extends StatelessWidget {
  const PekerjaanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Pekerjaan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Kelola semua pekerjaan Anda di sini",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildPekerjaanCard(
            "3",
            "Pekerjaan Baru",
            "Menunggu konfirmasi",
            const PekerjaanBaruScreen(),
            context,
            Colors.green,
          ),
          _buildPekerjaanCard(
            "2",
            "Sedang Dikerjakan",
            "Dalam proses pengerjaan",
            const SedangDikerjakanScreen(),
            context,
            Colors.orange,
          ),
          _buildPekerjaanCard(
            "4",
            "Selesai",
            "Telah diselesaikan",
            const PekerjaanSelesaiScreen(),
            context,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPekerjaanCard(
    String count,
    String title,
    String subtitle,
    Widget targetPage,
    BuildContext context,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF1A1AFF),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tambahkan BerandaTeknisiScreen jika belum ada
class BerandaTeknisiScreen extends StatelessWidget {
  const BerandaTeknisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1AFF), Color(0xFF3366FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selamat Datang,",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Laela Fazah Fitriani!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Teknisi Professional",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Stats
          const Text(
            "Statistik Hari Ini",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard("3", "Pekerjaan Baru", Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard("2", "Sedang Dikerjakan", Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard("4", "Selesai", Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard("Rp 1.3jt", "Pendapatan", Colors.purple),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            "Aksi Cepat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            children: [
              _buildQuickAction(Icons.work_outline, "Pekerjaan Baru", const PekerjaanBaruScreen(), context),
              _buildQuickAction(Icons.build_circle, "Sedang Dikerjakan", const SedangDikerjakanScreen(), context),
              _buildQuickAction(Icons.check_circle, "Pekerjaan Selesai", const PekerjaanSelesaiScreen(), context),
              _buildQuickAction(Icons.attach_money, "Pendapatan", const PendapatanTeknisiScreen(), context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Widget targetPage, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A1AFF), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}