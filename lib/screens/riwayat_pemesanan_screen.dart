import 'package:flutter/material.dart';

class RiwayatPemesananScreen extends StatefulWidget {
  const RiwayatPemesananScreen({super.key});

  @override
  State<RiwayatPemesananScreen> createState() => _RiwayatPemesananScreenState();
}

class _RiwayatPemesananScreenState extends State<RiwayatPemesananScreen> {
  final Color primaryBlue = const Color(0xFF1A1AFF);
  int _currentIndex = 0; // Untuk menandai menu aktif

  void _onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search'); // pastikan route ini ada
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/teknisi'); // pastikan route ini ada
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chat'); // pastikan route ini ada
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile'); // pastikan route ini ada
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pemesanan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryBlue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _riwayatCard('TRX-176533001', '16-09-2025', 'Di Proses', primaryBlue),
            const SizedBox(height: 8),
            _riwayatCard('TRX-176533001', '16-09-2025', 'Di Kerjakan', Colors.orange),
            const SizedBox(height: 8),
            _riwayatCard('TRX-176533001', '16-09-2025', 'Selesai', Colors.green),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pencarian'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Daftar Teknisi'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _riwayatCard(String trx, String tanggal, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Info kiri
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trx,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),

          // Info kanan
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(tanggal, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              const Text('Total: Rp. 220.000', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
