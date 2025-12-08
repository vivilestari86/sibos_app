import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';
import 'package:sibos_app/screens/pendapatan_teknisi_screen.dart';
import 'package:sibos_app/screens/profile_teknisi_screen.dart';
import 'package:sibos_app/screens/pekerjaan_baru_screen.dart';
import 'package:sibos_app/screens/sedang_dikerjakan_screen.dart';
import 'package:sibos_app/screens/pekerjaan_selesai_screen.dart';
import 'package:sibos_app/screens/beranda_teknisi_screen.dart';
import 'package:sibos_app/services/auth_service.dart';

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
        elevation: 2,
        shadowColor: Colors.black12,
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.chat, color: Colors.white, size: 20),
              ),
              onPressed: _launchWhatsApp,
            ),
          ),
          // Tombol Logout
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
              ),
              onPressed: _logout,
            ),
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
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A1AFF),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.home_outlined,
                  size: 22,
                  color: _selectedIndex == 0 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.home_filled, color: Color(0xFF1A1AFF), size: 22),
              ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.work_outline,
                  size: 22,
                  color: _selectedIndex == 1 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.work, color: Color(0xFF1A1AFF), size: 22),
              ),
              label: 'Pekerjaan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.attach_money_outlined,
                  size: 22,
                  color: _selectedIndex == 2 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.attach_money, color: Color(0xFF1A1AFF), size: 22),
              ),
              label: 'Pendapatan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  Icons.person_outline,
                  size: 22,
                  color: _selectedIndex == 3 
                      ? const Color(0xFF1A1AFF) 
                      : const Color(0xFF94A3B8),
                ),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF1A1AFF), size: 22),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class PekerjaanTab extends StatefulWidget {
  const PekerjaanTab({super.key});

  @override
  _PekerjaanTabState createState() => _PekerjaanTabState();
}

class _PekerjaanTabState extends State<PekerjaanTab> {

  // ==============================
  // METHOD FETCH SUMMARY
  // ==============================
  Future<Map<String, dynamic>> fetchSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    // == GET pekerjaan baru ==
    final baruRes = await http.get(
      Uri.parse("${AppConfig.baseUrl}/pekerjaan-baru"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    final baru = jsonDecode(baruRes.body);
    final totalBaru = baru['data']?.length ?? 0;

    // == GET sedang dikerjakan ==
    final dikerjakanRes = await http.get(
      Uri.parse("${AppConfig.baseUrl}/pekerjaan/dikerjakan"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    final dikerjakan = jsonDecode(dikerjakanRes.body);
    final totalDikerjakan = dikerjakan.length;

    // == GET pekerjaan selesai ==
    final selesaiRes = await http.get(
      Uri.parse("${AppConfig.baseUrl}/pekerjaan/riwayat"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    final selesaiDecoded = jsonDecode(selesaiRes.body);

    List selesaiList;
    if (selesaiDecoded is List) {
      selesaiList = selesaiDecoded;
    } else if (selesaiDecoded is Map && selesaiDecoded['data'] is List) {
      selesaiList = selesaiDecoded['data'];
    } else if (selesaiDecoded is Map && selesaiDecoded['selesai'] is List) {
      selesaiList = selesaiDecoded['selesai'];
    } else {
      selesaiList = [];
    }

    final totalSelesai = selesaiList.length;

    // == Hitung pendapatan ==
    int totalPendapatan = 0;
    for (var job in selesaiList) {
      final harga = int.tryParse(job['total_harga'].toString().split(".")[0]) ?? 0;
      totalPendapatan += harga;
    }

    return {
      "baru": totalBaru,
      "dikerjakan": totalDikerjakan,
      "selesai": totalSelesai,
      "pendapatan": totalPendapatan,
    };
  }

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
          const SizedBox(height: 6),
          const Text(
            "Kelola semua pekerjaan Anda di sini",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          FutureBuilder<Map<String, dynamic>>(
            future: fetchSummary(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!;

              return Column(
                children: [
                  _buildPekerjaanCard(
                    data["baru"].toString(),
                    "Pekerjaan Baru",
                    "Menunggu konfirmasi",
                    const PekerjaanBaruScreen(),
                    context,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 12),
                  _buildPekerjaanCard(
                    data["dikerjakan"].toString(),
                    "Sedang Dikerjakan",
                    "Dalam proses pengerjaan",
                    const SedangDikerjakanScreen(),
                    context,
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 12),
                  _buildPekerjaanCard(
                    data["selesai"].toString(),
                    "Selesai",
                    "Telah diselesaikan",
                    const PekerjaanSelesaiScreen(),
                    context,
                    const Color(0xFF3B82F6),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                count,
                style: TextStyle(
                  fontSize: 18,
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
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1AFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF1A1AFF),
                size: 16,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }


class BerandaTeknisiScreen extends StatefulWidget {
  const BerandaTeknisiScreen({super.key});
  
  @override
  State<BerandaTeknisiScreen> createState() => _BerandaTeknisiScreenState();
}

class _BerandaTeknisiScreenState extends State<BerandaTeknisiScreen> {
  String namaTeknisi = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }
// Ambil nama dari API profile customer
  Future<void> loadProfile() async {
    final data = await AuthService.getProfile();

    if (mounted) {
      setState(() {
        namaTeknisi = data['name'] ?? "Teknisi";
      });
    }
  }

  
  Future<Map<String, dynamic>> fetchSummary() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  // == GET pekerjaan baru ==
  final baruRes = await http.get(
    Uri.parse("${AppConfig.baseUrl}/pekerjaan-baru"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  final baru = jsonDecode(baruRes.body);
  final totalBaru = baru['data']?.length ?? 0;

  // == GET sedang dikerjakan ==
  final dikerjakanRes = await http.get(
    Uri.parse("${AppConfig.baseUrl}/pekerjaan/dikerjakan"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  final dikerjakan = jsonDecode(dikerjakanRes.body);
  final totalDikerjakan = dikerjakan.length;

  // == GET pekerjaan selesai ==
  final selesaiRes = await http.get(
    Uri.parse("${AppConfig.baseUrl}/pekerjaan/riwayat"),
    headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    },
  );

  final selesaiDecoded = jsonDecode(selesaiRes.body);

  List selesaiList;
  if (selesaiDecoded is List) {
    selesaiList = selesaiDecoded;
  } else if (selesaiDecoded is Map && selesaiDecoded['data'] is List) {
    selesaiList = selesaiDecoded['data'];
  } else if (selesaiDecoded is Map && selesaiDecoded['selesai'] is List) {
    selesaiList = selesaiDecoded['selesai'];
  } else {
    selesaiList = [];
  }

  final totalSelesai = selesaiList.length;

  // == Hitung pendapatan ==
  int totalPendapatan = 0;
  for (var job in selesaiList) {
    final harga = int.tryParse(job['total_harga'].toString().split(".")[0]) ?? 0;
    totalPendapatan += harga;
  }

  // == RETURN ==
  return {
    "baru": totalBaru,
    "dikerjakan": totalDikerjakan,
    "selesai": totalSelesai,
    "pendapatan": totalPendapatan,
  };
}



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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1AFF).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
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
                 Text(
                  "$namaTeknisi",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          const SizedBox(height: 28),

          // Quick Stats
const Text(
  "Statistik Hari Ini",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1E293B),
  ),
),

const SizedBox(height: 16),

// ========================
// FIXED — FutureBuilder 
// ========================
FutureBuilder(
  future: fetchSummary(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data ?? {};

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                data["baru"].toString(),
                "Pekerjaan Baru",
                const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                data["dikerjakan"].toString(),
                "Sedang Dikerjakan",
                const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                data["selesai"].toString(),
                "Selesai",
                const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "Rp ${NumberFormat.decimalPattern('id').format(data['pendapatan'])}",
                "Pendapatan",
                const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  },
),

const SizedBox(height: 28),


          // Quick Actions
          const Text(
            "Aksi Cepat",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
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
              childAspectRatio: 1.4,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
              fontSize: 13,
              fontWeight: FontWeight.w500,
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A1AFF), size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
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