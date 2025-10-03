import 'package:flutter/material.dart';

class EditProfileTeknisiScreen extends StatefulWidget {
  const EditProfileTeknisiScreen({super.key});

  @override
  State<EditProfileTeknisiScreen> createState() =>
      _EditProfileTeknisiScreenState();
}

class _EditProfileTeknisiScreenState extends State<EditProfileTeknisiScreen> {
  final TextEditingController _namaController =
      TextEditingController(text: "laela fazah fitriani");
  final TextEditingController _alamatController = TextEditingController(
      text:
          "Blok Bacok, RT 010/ RW 05, Desa Segeran Lor, Kec. Juntinyuat, Kab. Indramayu");
  final TextEditingController _noHpController =
      TextEditingController(text: "083195576047");
  final TextEditingController _emailController =
      TextEditingController(text: "laelafazah26@gmail.com");

  String _jenisKelamin = "Perempuan";

  void _simpanPerubahan() {
    // TODO: Hubungkan ke API Laravel
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
                    "EDIT PROFIL",
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

            // ================= FORM =================
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

  // ================= WIDGET REUSABLE =================
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
