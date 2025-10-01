import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:sibos_app/screens/teknisi_success_screen.dart';

class TeknisiFormScreen extends StatefulWidget {
  const TeknisiFormScreen({super.key});

  @override
  State<TeknisiFormScreen> createState() => _TeknisiFormScreenState();
}

class _TeknisiFormScreenState extends State<TeknisiFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  String? _jenisKelamin;
  String? _keahlian;

  final List<String> _jenisKelaminList = ['Laki-laki', 'Perempuan'];
  final List<String> _keahlianList = [
    'Service AC',
    'Service Kulkas',
    'Service Mesin Cuci',
    'Service TV',
    'Service Kipas',
    'Instalasi Listrik',
    'Cleaning Service Harian',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==================== Header (disamakan dengan Register) ====================
              Container(
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1AFF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(150),
                    bottomRight: Radius.circular(150),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_repair_service, color: Colors.white, size: 50),
                      SizedBox(height: 10),
                      Text(
                        "Selamat Datang\nHalaman Teknisi Layanan Rumah Tangga",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Daftarkan diri sesuai dengan keahlian Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ==================== Judul Form ====================
              const Text(
                "FORM PENGAJUAN TEKNISI",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1AFF),
                ),
              ),
              const SizedBox(height: 20),

              // ==================== Form ====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(labelText: "Nama"),
                        validator: (value) =>
                            value!.isEmpty ? "Nama wajib diisi" : null,
                      ),
                      TextFormField(
                        controller: _alamatController,
                        decoration: const InputDecoration(labelText: "Alamat"),
                        validator: (value) =>
                            value!.isEmpty ? "Alamat wajib diisi" : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _jenisKelamin,
                        hint: const Text("Jenis kelamin"),
                        items: _jenisKelaminList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _jenisKelamin = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Pilih jenis kelamin" : null,
                      ),
                      TextFormField(
                        controller: _noHpController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: "No. Handphone"),
                        validator: (value) =>
                            value!.isEmpty ? "No. HP wajib diisi" : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _keahlian,
                        hint: const Text("Keahlian"),
                        items: _keahlianList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _keahlian = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Pilih keahlian" : null,
                      ),
                      const SizedBox(height: 20),

                      // ==================== Tombol Kirim ====================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1AFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacementNamed(context, '/teknisi-success');
                            }
                          },
                          child: const Text(
                            "Kirim",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
