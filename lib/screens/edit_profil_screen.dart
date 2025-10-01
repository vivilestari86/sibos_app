import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _namaController =
      TextEditingController(text: "Vivi Lestari");
  final TextEditingController _alamatController = TextEditingController(
      text:
          "Blok Kali kulon, RT 014/ RW 007, Desa Drunten wetan, Kec. Gabuswetan, Kab. Indramayu");
  final TextEditingController _noHpController =
      TextEditingController(text: "0812-8082-3794");
  final TextEditingController _emailController =
      TextEditingController(text: "vivilestari@gmail.com");

  String _jenisKelamin = "Perempuan";

  void _simpanPerubahan() {
    // Nanti ini bisa dihubungkan ke backend API Laravel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan profil berhasil disimpan')),
    );
    Navigator.pop(context); // kembali ke halaman profil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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

            _buildTextField("Nama", _namaController),
            _buildTextField("Alamat", _alamatController, maxLines: 3),
            _buildTextField("No Handphone", _noHpController),

            // Dropdown jenis kelamin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Jenis Kelamin",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _jenisKelamin,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: "Perempuan",
                          child: Text("Perempuan"),
                        ),
                        DropdownMenuItem(
                          value: "Laki-laki",
                          child: Text("Laki-laki"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            _buildTextField("Email", _emailController),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simpanPerubahan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Simpan"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
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
