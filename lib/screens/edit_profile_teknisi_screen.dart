import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibos_app/services/auth_service.dart';

class EditProfileTeknisiScreen extends StatefulWidget {
  final Map<String, dynamic> teknisi;

  const EditProfileTeknisiScreen({
    super.key,
    required this.teknisi,
  });

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
        TextEditingController(text: t['pengalaman_kerja'] ?? '');
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

    final dataUpdate = {
      "nama": _namaController.text.trim(),
      "alamat": _alamatController.text.trim(),
      "no_hp": _noHpController.text.trim(),
      "keahlian": _keahlianController.text.trim(),
      "pengalaman_kerja": _pengalamanController.text.trim(),
      // jangan masukkan key sertifikat di JSON biasa — sertifikat akan dikirim sebagai file multipart
    };

    try {
      // Contoh pemanggilan: pastikan AuthService.updateProfileTeknisi mendukung parameter file optional
      // Jika implementasimu berbeda, sesuaikan panggilan di sini.
      final response = await AuthService.updateProfileTeknisi(
        dataUpdate,
        file: _pickedImage, // bisa null jika tidak mengganti sertifikat
      );

      setState(() => isLoading = false);

      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // kembalikan success ke layar sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Gagal mengupdate profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.teknisi;
    final existingSertifikatUrl = t['sertifikat'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil Teknisi"),
        backgroundColor: const Color(0xFF1A1AFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildField("Nama Teknisi", _namaController),
            _buildField("Alamat", _alamatController, maxLines: 2),
            _buildField("No HP", _noHpController, keyboard: TextInputType.phone),
            _buildField("Keahlian", _keahlianController),
            _buildField("Pengalaman Kerja", _pengalamanController, maxLines: 3),

            const SizedBox(height: 8),
            const Text("Sertifikat",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // Preview sertifikat: prioritas file yang dipilih, jika tidak ada tampilkan URL dari server
            GestureDetector(
              onTap: _pickImage,
              child: _pickedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _pickedImage!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (existingSertifikatUrl != null &&
                          existingSertifikatUrl.toString().isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            existingSertifikatUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              height: 160,
                              color: Colors.grey[200],
                              child: const Center(child: Text("Gagal load gambar")),
                            ),
                          ),
                        )
                      : Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                          child: const Center(
                            child: Text("Belum ada sertifikat\n(Tap untuk pilih)"),
                          ),
                        ),
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pilih Gambar"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _simpanPerubahan,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ))
                        : const Icon(Icons.save),
                    label: Text(isLoading ? "Menyimpan..." : "Simpan Perubahan"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1AFF),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
