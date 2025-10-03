import 'package:flutter/material.dart';
import 'package:sibos_app/screens/edit_profile_teknisi_screen.dart';

class ProfileTeknisiScreen extends StatelessWidget {
  const ProfileTeknisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1AFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.person, size: 80, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    "PROFIL SAYA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= DATA PROFIL =================
            _buildInfoField("Nama", "laela fazah fitriani"),
            _buildInfoField("Alamat",
                "Blok Bacok, RT 010/ RW 05, Desa Segeran Lor, Kec. Juntinyuat, Kab. Indramayu"),
            _buildInfoField("No Handphone", "083195576047"),
            _buildInfoField("Jenis Kelamin", "Perempuan"),
            _buildInfoField("Email", "laelafazah26@gmail.com"),

            const SizedBox(height: 16),

            // ================= BUTTON EDIT =================
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileTeknisiScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Edit"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET REUSABLE =================
  static Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextFormField(
            readOnly: true,
            initialValue: value,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
