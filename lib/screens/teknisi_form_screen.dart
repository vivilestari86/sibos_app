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
  bool _isChecking = true; // Tambahan: untuk menunggu pengecekan status

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
  void initState() {
    super.initState();
    _checkIfAlreadyRegistered();
  }

Future<void> _checkIfAlreadyRegistered() async {
  final result = await AuthService.checkTeknisiStatus();

  if (!mounted) return;

  if (result['status'] == 'registered') {
    // tidak render form sama sekali → langsung redirect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/teknisi-success');
    });
  } else {
    setState(() => _isChecking = false);
  }
}


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
    // Cek status sebelum submit
    final status = await AuthService.checkTeknisiStatus();
if (status['status'] == 'registered') {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacementNamed(context, '/teknisi-success');
  });
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
    if (_isChecking || _isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // =======================
              // Header
              // =======================
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

              // =======================
              // Form
              // =======================
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
                            DropdownButtonFormField<String>(
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
                            const SizedBox(height: 20),

                            // Pengalaman
                            TextFormField(
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
                            const SizedBox(height: 20),

                            // Unggah Sertifikat
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
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(height: 12),
                                
                                GestureDetector(
                                  onTap: _pickSertifikat,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: _sertifikatFile == null
                                          ? Colors.white
                                          : Colors.green.withOpacity(0.05),
                                      border: Border.all(
                                        color: _sertifikatFile == null
                                            ? const Color(0xFF1A1AFF).withOpacity(0.3)
                                            : Colors.green,
                                        width: _sertifikatFile == null ? 1.5 : 2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          _sertifikatFile == null
                                              ? Icons.upload_file
                                              : Icons.check_circle,
                                          color: _sertifikatFile == null
                                              ? const Color(0xFF1A1AFF)
                                              : Colors.green,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _sertifikatFile == null
                                              ? "Tap untuk memilih file"
                                              : _sertifikatFile!.path.split('/').last,
                                          style: TextStyle(
                                            color: _sertifikatFile == null
                                                ? const Color(0xFF1A1AFF)
                                                : Colors.black87,
                                            fontWeight: _sertifikatFile == null
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (_sertifikatFile == null)
                                  Row(
                                    children: const [
                                      Icon(Icons.warning_amber_rounded,
                                          color: Colors.orange, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        "Sertifikat wajib diunggah",
                                        style: TextStyle(color: Colors.orange, fontSize: 12),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      Icon(Icons.verified, color: Colors.green[600], size: 14),
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
                              ],
                            ),
                            const SizedBox(height: 30),

                            // Submit
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: const Color(0xFF1A1AFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      "Kirim Pengajuan",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
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
