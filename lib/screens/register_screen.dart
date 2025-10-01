import 'package:flutter/material.dart';

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      // nanti ini bisa diganti API call (http.post)
      print("Nama: ${_namaController.text}");
      print("Alamat: ${_alamatController.text}");
      print("No HP: ${_noHpController.text}");
      print("Gender: $gender");
      print("Email: ${_emailController.text}");
      print("Username: ${_usernameController.text}");
      print("Password: ${_passwordController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil daftar (dummy)!")),
      );
      // arahkan ke halaman login
      Navigator.pop(context);
    }
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
                    Icon(Icons.home, color: Colors.white, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Selamat Datang\ndi Layanan Service Rumah Tangga",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Nikmati layanan kami sesuai kebutuhan anda",
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
            const Text(
              "DAFTAR",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1AFF),
              ),
            ),
            const SizedBox(height: 20),

            // Form
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
                    TextFormField(
                      controller: _noHpController,
                      decoration: const InputDecoration(labelText: "No Handphone"),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? "No HP wajib diisi" : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: gender,
                      hint: const Text("Jenis kelamin"),
                      items: ["Laki-laki", "Perempuan"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          gender = val;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Pilih jenis kelamin" : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? "Email wajib diisi" : null,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                      validator: (value) =>
                          value!.isEmpty ? "Username wajib diisi" : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? "Password wajib diisi" : null,
                    ),
                    const SizedBox(height: 20),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A1AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _register,
                        child: const Text(
                          "Daftar",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
