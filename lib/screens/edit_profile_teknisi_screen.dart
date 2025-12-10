import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibos_app/services/auth_service.dart';

class EditProfileTeknisiScreen extends StatefulWidget {
  final Map<String, dynamic> teknisi;

  const EditProfileTeknisiScreen({super.key, required this.teknisi});

  @override
  State<EditProfileTeknisiScreen> createState() =>
      _EditProfileTeknisiScreenState();
}

class _EditProfileTeknisiScreenState extends State<EditProfileTeknisiScreen> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;
  late TextEditingController _keahlianController;
  late TextEditingController _pengalamanController;

  File? _pickedImage;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final t = widget.teknisi;

    _namaController = TextEditingController(text: t['nama'] ?? '');
    _alamatController = TextEditingController(text: t['alamat'] ?? '');
    _noHpController = TextEditingController(text: t['no_hp'] ?? '');
    _keahlianController = TextEditingController(text: t['keahlian'] ?? '');
    _pengalamanController =
        TextEditingController(text: t['pengalaman'] ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    _keahlianController.dispose();
    _pengalamanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _simpanPerubahan() async {
  setState(() => isLoading = true);

  try {
    final resTeknisi = await AuthService.updateProfileTeknisi(
      {
        "keahlian": _keahlianController.text.trim(),
        "pengalaman": _pengalamanController.text.trim(),
      },
      file: _pickedImage,
    );

    setState(() => isLoading = false);

    if (resTeknisi['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diperbarui!'),
          backgroundColor: const Color.fromARGB(255, 46, 3, 237),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resTeknisi['message'] ?? 'Gagal mengupdate profil'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terjadi kesalahan: $e'),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final t = widget.teknisi;
    final existingSertifikatUrl = t['sertifikat'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 🔹 Header dengan SliverAppBar
          SliverAppBar(
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1AFF),
                      Color(0xFF6366F1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back button dan title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Edit Profil",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Color(0xFF1A1AFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Form Edit Profil
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔹 Card Informasi Pribadi
                  _buildEditSection(
                    title: "Informasi Pribadi",
                    icon: Icons.person_outline,
                    children: [
                      _buildEditField(
                        icon: Icons.person,
                        label: "Nama Lengkap",
                        controller: _namaController,
                        hintText: "Masukkan nama lengkap",
                      ),
                      _buildEditField(
                        icon: Icons.phone,
                        label: "No Handphone",
                        controller: _noHpController,
                        hintText: "Masukkan nomor handphone",
                        keyboardType: TextInputType.phone,
                      ),
                      _buildEditField(
                        icon: Icons.location_on,
                        label: "Alamat",
                        controller: _alamatController,
                        hintText: "Masukkan alamat lengkap",
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Card Informasi Teknis
                  _buildEditSection(
                    title: "Informasi Teknis",
                    icon: Icons.build_outlined,
                    children: [
                      _buildEditField(
                        icon: Icons.settings,
                        label: "Keahlian",
                        controller: _keahlianController,
                        hintText: "Masukkan keahlian (contoh: Service Kulkas)",
                      ),
                      _buildEditField(
                        icon: Icons.work_history,
                        label: "Pengalaman Kerja",
                        controller: _pengalamanController,
                        hintText: "Masukkan pengalaman kerja",
                        maxLines: 3,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Card Dokumen Sertifikat
                  _buildEditSection(
                    title: "Dokumen Sertifikat",
                    icon: Icons.description_outlined,
                    children: [
                      // Label Sertifikat
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1AFF).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library,
                              color: Color(0xFF1A1AFF),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Sertifikat",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Gambar Sertifikat
                      GestureDetector(
                        onTap: _pickImage,
                        child: _pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _pickedImage!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (existingSertifikatUrl != null &&
                                    existingSertifikatUrl.toString().isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      existingSertifikatUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.3)),
                                        ),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error, color: Colors.grey),
                                              SizedBox(height: 8),
                                              Text("Gagal memuat gambar"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_library,
                                              color: Colors.grey, size: 40),
                                          SizedBox(height: 8),
                                          Text(
                                            "Belum ada sertifikat\n(Tap untuk pilih)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                      ),
                      const SizedBox(height: 12),

                      // Tombol Pilih Gambar
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1A1AFF),
                            width: 1.5,
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library,
                              color: Color(0xFF1A1AFF), size: 20),
                          label: const Text(
                            "Pilih Gambar Sertifikat",
                            style: TextStyle(
                              color: Color(0xFF1A1AFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🔹 Tombol Simpan
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1A1AFF),
                          Color(0xFF6366F1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A1AFF).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _simpanPerubahan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  "Simpan Perubahan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  // 🔹 Widget untuk section edit
  Widget _buildEditSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1AFF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF1A1AFF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1AFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),
            // Content
            Column(
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget untuk field edit
  Widget _buildEditField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label dengan icon
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1AFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1A1AFF),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Text Field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1A1AFF),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}