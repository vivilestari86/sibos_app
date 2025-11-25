import 'package:flutter/material.dart';
import 'package:sibos_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk ambil input user
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noHpController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? gender;
  bool _isLoading = false;

  @override
  void dispose() {
    // buang controller biar gak bocor memory
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis kelamin terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.register(
      name: _namaController.text,
      alamat: _alamatController.text,
      noHp: _noHpController.text,
      gender: gender!,
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['message'].toString().toLowerCase().contains('berhasil')
              ? const Color.fromARGB(255, 46, 3, 237)
              : Colors.red,
        ),
      );

      // kalau berhasil daftar, baru balik ke halaman login
      if (result['message'].toString().toLowerCase().contains('berhasil')) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mendaftar"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan lengkungan lebih kecil
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A1AFF), Color(0xFF0066FF)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(Icons.home_work, color: Colors.white.withOpacity(0.1), size: 80),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 20,
                    child: Icon(Icons.cleaning_services, color: Colors.white.withOpacity(0.1), size: 60),
                  ),
                  
                  // Content
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person_add_alt_1,
                            color: Color(0xFF1A1AFF),
                            size: 35,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Buat Akun Baru",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Daftar sekarang dan nikmati layanan rumah tangga terbaik",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            
            // Title
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "FORM PENDAFTARAN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1AFF),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // Form dalam layout vertikal semua (satu kolom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _namaController,
                          label: "Nama Lengkap",
                          icon: Icons.person_outline,
                          validator: (value) =>
                              value!.isEmpty ? "Nama wajib diisi" : null,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _alamatController,
                          label: "Alamat Lengkap",
                          icon: Icons.home_outlined,
                          validator: (value) =>
                              value!.isEmpty ? "Alamat wajib diisi" : null,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _noHpController,
                          label: "No Handphone",
                          icon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty ? "No HP wajib diisi" : null,
                        ),
                        const SizedBox(height: 15),

                        // Dropdown dengan style yang lebih baik
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              hint: const Row(
                                children: [
                                  Icon(Icons.transgender, size: 18, color: Colors.grey),
                                  SizedBox(width: 8),
                                  Text("Pilih Jenis Kelamin"),
                                ],
                              ),
                              items: ["Laki-laki", "Perempuan"]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Icon(
                                              e == "Laki-laki" 
                                                  ? Icons.male 
                                                  : Icons.female,
                                              color: const Color(0xFF1A1AFF),
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(e),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  gender = val;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              validator: (value) =>
                                  value == null ? "Pilih jenis kelamin" : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty ? "Email wajib diisi" : null,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _usernameController,
                          label: "Username",
                          icon: Icons.person_pin,
                          validator: (value) =>
                              value!.isEmpty ? "Username wajib diisi" : null,
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: _passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? "Password wajib diisi" : null,
                        ),
                        const SizedBox(height: 25),

                        // Tombol Daftar dengan loading indicator
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1AFF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: Colors.blue.withOpacity(0.5),
                            ),
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Daftar Sekarang",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Link untuk kembali ke login
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Sudah punya akun? Masuk di sini",
                            style: TextStyle(
                              color: Color(0xFF1A1AFF),
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
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // Helper method untuk membuat text field yang konsisten
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF1A1AFF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A1AFF), width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
      validator: validator,
    );
  }
}