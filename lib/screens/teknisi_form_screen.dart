import 'package:flutter/material.dart';
import 'package:sibos_app/services/auth_service.dart';

class TeknisiFormScreen extends StatefulWidget {
  const TeknisiFormScreen({super.key});

  @override
  State<TeknisiFormScreen> createState() => _TeknisiFormScreenState();
}

class _TeknisiFormScreenState extends State<TeknisiFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _pengalamanController = TextEditingController();
  final TextEditingController _sertifikatController = TextEditingController();
  String? _keahlian;

  final List<String> _keahlianList = [
    'Service AC',
    'Service Kulkas',
    'Service Mesin Cuci',
    'Service TV',
    'Service Kipas Angin',
    'Instalasi Listrik',
    'Cleaning Service Harian',
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ==================== Header ====================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
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
                        "Pendaftaran Teknisi Layanan Rumah Tangga",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Lengkapi data berikut sesuai pengalaman dan sertifikat Anda",
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
                "FORM PENDAFTARAN TEKNISI",
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
                      // Nama
                      TextFormField(
                        controller: _namaController,
                        decoration: const InputDecoration(labelText: "Nama Lengkap"),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Nama wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Alamat
                      TextFormField(
                        controller: _alamatController,
                        decoration: const InputDecoration(labelText: "Alamat"),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Alamat wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Telepon
                      TextFormField(
                        controller: _teleponController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: "Telepon"),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Telepon wajib diisi" : null,
                      ),
                      const SizedBox(height: 15),

                      // Dropdown Keahlian
                      DropdownButtonFormField<String>(
                        value: _keahlian,
                        hint: const Text("Pilih Keahlian"),
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
                            value == null ? "Pilih salah satu keahlian" : null,
                      ),
                      const SizedBox(height: 15),

                      // Pengalaman
                      TextFormField(
                        controller: _pengalamanController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Pengalaman Kerja (contoh: 2 tahun di bidang AC)",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Pengalaman wajib diisi";
                          }
                          if (!value.toLowerCase().contains("tahun")) {
                            return "Tuliskan pengalaman minimal 1 tahun kerja (gunakan format tahun)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      // Sertifikat
                      TextFormField(
                        controller: _sertifikatController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Nama atau Link Sertifikat (opsional)",
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Tombol Kirim
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
                          onPressed: _isLoading ? null : _handleSubmit,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await AuthService.registerAsTechnician(
        nama: _namaController.text,
        alamat: _alamatController.text,
        telepon: _teleponController.text,
        keahlian: _keahlian!,
        pengalaman: _pengalamanController.text,
        sertifikat: _sertifikatController.text.isNotEmpty
            ? _sertifikatController.text
            : null,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success'] == true ||
          (result['message']?.toString().toLowerCase().contains('berhasil') ??
              false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran teknisi berhasil ✅')),
        );
        Navigator.pushReplacementNamed(context, '/teknisi-success');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Gagal daftar teknisi ❌')),
        );
      }
    }
  }
}
