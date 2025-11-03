import 'package:flutter/material.dart';
import 'package:sibos_app/screens/edit_profil_screen.dart';
import 'package:sibos_app/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);

    final data = await AuthService.getProfile();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A1AFF)),
            )
          : RefreshIndicator(
              onRefresh: _loadProfile, // bisa tarik ke bawah buat refresh manual
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // 🔹 Header Profil
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
                      child: const Column(
                        children: [
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

                    // 🔹 Data Profil
                    _buildInfoField("Nama", userData?['name'] ?? '-'),
                    _buildInfoField("Alamat", userData?['alamat'] ?? '-'),
                    _buildInfoField("No Handphone", userData?['no_hp'] ?? '-'),
                    _buildInfoField("Jenis Kelamin", userData?['gender'] ?? '-'),
                    _buildInfoField("Email", userData?['email'] ?? '-'),

                    const SizedBox(height: 16),

                    // 🔹 Tombol Edit
                    ElevatedButton(
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              initialData: userData ?? {},
                            ),
                          ),
                        );

                        if (updated == true) {
                          await _loadProfile(); // 🔁 Refresh data setelah edit
                        }
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
            ),
    );
  }

  // 🔹 Widget bantu untuk tampilkan setiap field profil
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
