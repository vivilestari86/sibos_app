import 'package:flutter/material.dart';
import 'package:sibos_app/services/auth_service.dart';
import 'edit_profile_teknisi_screen.dart';

class ProfileTeknisiScreen extends StatefulWidget {
  const ProfileTeknisiScreen({super.key});

  @override
  State<ProfileTeknisiScreen> createState() => _ProfileTeknisiScreenState();
}

class _ProfileTeknisiScreenState extends State<ProfileTeknisiScreen> {
  Map<String, dynamic>? teknisi;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await AuthService.checkTeknisiStatus();
    if (mounted) {
      setState(() {
        teknisi = data['data'];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (teknisi == null) {
      return const Scaffold(
        body: Center(child: Text("Data teknisi tidak ditemukan.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Profil Saya",
          style: TextStyle(
              color: Color(0xFF1A1AFF),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //
            // === PROFILE HEADER ===
            //
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.1))),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1A1AFF).withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.person,
                        color: Color(0xFF1A1AFF), size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    teknisi!['nama'] ?? "-",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Teknisi",
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //
            // === INFORMASI DETAIL ===
            //
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Informasi Teknisi",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B))),
                  const SizedBox(height: 16),

                  _buildInfoRow(Icons.person_outline, "Nama Teknisi",
                      teknisi!['nama'] ?? "-"),

                  _buildInfoRow(Icons.location_on_outlined, "Alamat",
                      teknisi!['alamat'] ?? "-"),

                  _buildInfoRow(Icons.phone_iphone, "No HP",
                      teknisi!['no_hp'] ?? "-"),

                  _buildInfoRow(Icons.build_outlined, "Keahlian",
                      teknisi!['keahlian'] ?? "-"),

                  _buildInfoRow(Icons.work_history_outlined,
                      "Pengalaman Kerja", teknisi!['pengalaman_kerja'] ?? "-"),

                  const SizedBox(height: 20),
                  const Text("Sertifikat",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  teknisi!['sertifikat'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            teknisi!['sertifikat'],
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Text("- Tidak ada sertifikat -",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B))),
                ],
              ),
            ),

            const SizedBox(height: 24),

            //
            // === EDIT BUTTON ===
            //
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1A1AFF)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileTeknisiScreen(
                                teknisi: teknisi!,
                              )));
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text("Edit Profil",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  //
  // === COMPONENT ROW ===
  //
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF).withOpacity(0.1),
                shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF1A1AFF), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
