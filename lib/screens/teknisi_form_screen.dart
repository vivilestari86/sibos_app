import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sibos_app/services/auth_service.dart';

class TeknisiFormScreen extends StatefulWidget {
  const TeknisiFormScreen({super.key});

  @override
  State<TeknisiFormScreen> createState() => _TeknisiFormScreenState();
}

class _TeknisiFormScreenState extends State<TeknisiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _keahlian;
  final TextEditingController _pengalamanController = TextEditingController();
  File? _sertifikatFile;
  bool _isLoading = false;

  @override
void initState() {
  super.initState();
  _checkIfAlreadyRegistered();
}

Future<void> _checkIfAlreadyRegistered() async {
  setState(() => _isLoading = true);
  final result = await AuthService.checkTeknisiStatus();
  setState(() => _isLoading = false);

  if (result['status'] == 'registered') {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/teknisi-success');
  }
}

  final List<String> _keahlianList = [
    'Service AC',
    'Service Kulkas',
    'Service Mesin Cuci',
    'Service TV',
    'Service Kipas',
    'Instalasi Listrik',
    'Cleaning Service Harian',
  ];

  Future<void> _pickSertifikat() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _sertifikatFile = File(result.files.single.path!);
      });
    }
  }

 Future<void> _handleSubmit() async {
  // 🔍 Cek dulu apakah sudah pernah daftar
  final status = await AuthService.checkTeknisiStatus();
  if (status['status'] == 'registered') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda sudah terdaftar sebagai teknisi.')),
    );
    return;
  }

  if (_formKey.currentState!.validate()) {
    if (_sertifikatFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sertifikat wajib diunggah')),
      );
      return;
    }

      setState(() => _isLoading = true);

      final result = await AuthService.registerAsTechnician(
        keahlian: _keahlian!,
        pengalaman: _pengalamanController.text,
        sertifikatFile: _sertifikatFile!,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['status'] == 'success' ||
          (result['message']?.toString().toLowerCase().contains('berhasil') ?? false)) {
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

  void _showFileRequirements() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF1A1AFF)),
            SizedBox(width: 8),
            Text('Format File Sertifikat'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File yang didukung:'),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('JPG/JPEG (Gambar)'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('PNG (Gambar)'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('PDF (Dokumen)'),
              ],
            ),
            SizedBox(height: 12),
            Text('Maksimal ukuran: 10MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ==================== Header ====================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 60, left: 24, right: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1A1AFF),
                      Colors.blue[700]!,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 20,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.engineering, size: 120, color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.build_circle_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Jadilah Bagian\nTeknisi Kami",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Daftarkan keahlian Anda dan mulailah karir sebagai teknisi profesional",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ==================== Form Container ====================
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.list_alt, color: Color(0xFF1A1AFF), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Form Pengajuan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1AFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Isi data dengan lengkap dan benar",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Keahlian Dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _keahlian,
                                hint: const Text("Pilih Keahlian"),
                                items: _keahlianList
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (value) => setState(() => _keahlian = value),
                                validator: (value) =>
                                    value == null ? "Keahlian wajib dipilih" : null,
                                decoration: InputDecoration(
                                  labelText: "Keahlian",
                                  labelStyle: const TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1AFF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.work_outline, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Pengalaman TextField
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _pengalamanController,
                                decoration: InputDecoration(
                                  labelText: "Pengalaman Kerja (minimal 1 tahun)",
                                  labelStyle: const TextStyle(color: Colors.blueGrey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                  prefixIcon: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1AFF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.history_edu, color: Colors.white, size: 20),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Masukkan pengalaman kerja";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ==================== BAGIAN UNGGAH SERTIFIKAT YANG DIPERBAIKI ====================
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Unggah Sertifikat",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: _showFileRequirements,
                                      child: const Icon(
                                        Icons.help_outline,
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Format: JPG, PNG, PDF (Maks. 10MB)",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Container Unggah File
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _sertifikatFile == null 
                                          ? const Color(0xFF1A1AFF).withOpacity(0.3)
                                          : Colors.green,
                                      width: _sertifikatFile == null ? 1.5 : 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: _sertifikatFile == null 
                                        ? Colors.white
                                        : Colors.green.withOpacity(0.05),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _pickSertifikat,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: _sertifikatFile == null
                                            // Tampilan saat belum upload
                                            ? Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF1A1AFF).withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.upload_file,
                                                      color: Color(0xFF1A1AFF),
                                                      size: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    "Tap untuk memilih file",
                                                    style: TextStyle(
                                                      color: Color(0xFF1A1AFF),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  const Text(
                                                    "Sertifikat keahlian atau pelatihan",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )
                                            // Tampilan saat sudah upload
                                            : Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green.withOpacity(0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  const Text(
                                                    "File Berhasil Diunggah",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    _sertifikatFile!.path.split('/').last,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF1A1AFF),
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: const Text(
                                                      "Ubah File",
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
                                    ),
                                  ),
                                ),
                                
                                // Pesan status
                                if (_sertifikatFile == null)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.orange,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Sertifikat wajib diunggah",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.green[600],
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "File siap diupload",
                                          style: TextStyle(
                                            color: Colors.green[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1A1AFF),
                                    Color(0xFF3366FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Kirim Pengajuan",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                                        ],
                                      ),
                              ),
                            ),
                          ],
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