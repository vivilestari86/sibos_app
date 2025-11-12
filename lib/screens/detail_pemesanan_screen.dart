import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:sibos_app/config.dart';
import 'package:sibos_app/screens/midtrans_payment_screen.dart';

class DetailPemesananScreen extends StatefulWidget {
  final int serviceId;
  final String serviceTitle;
  final String imagePath;

  const DetailPemesananScreen({
    super.key,
    required this.serviceId,
    required this.serviceTitle,
    required this.imagePath,
  });

  @override
  State<DetailPemesananScreen> createState() => _DetailPemesananScreenState();
}

class _DetailPemesananScreenState extends State<DetailPemesananScreen> {
  String? _selectedPayment;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Map<String, dynamic>? _customerData;
  Map<String, dynamic>? _serviceData;
  bool _isLoading = true;
  bool _isSubmitting = false;

  final primaryBlue = const Color(0xFF1A1AFF);

  final String baseUrl = AppConfig.baseUrl;
  final String imageBaseUrl = AppConfig.imageBaseUrl;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchCustomerProfile(),
      _fetchServiceDetail(widget.serviceId),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _fetchCustomerProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _customerData = data['data'];
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetch profile: $e");
    }
  }

  Future<void> _fetchServiceDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/layanans/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _serviceData = data['data'];
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetch service detail: $e");
    }
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'Pilih Tanggal Pembersihan',
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Pilih Waktu Pembersihan',
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // ✅ Fungsi buat pesanan setelah pembayaran Midtrans sukses
  Future<void> buatPesananSetelahPembayaran() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan");

      final jadwalService = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
      );

      final harga = _serviceData?['harga'] ?? 0;

      final response = await http.post(
        Uri.parse('$baseUrl/pemesanan'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'layanan_id': widget.serviceId,
          'jadwal_service': jadwalService,
          'total_harga': harga,
          'metode_pembayaran': 'Transfer',
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("✅ Pesanan dibuat setelah pembayaran Midtrans: $data");
    } catch (e) {
      debugPrint('❌ Gagal buat pesanan setelah pembayaran: $e');
    }
  }

  // ✅ Fungsi bayar dengan Midtrans
  Future<void> _bayarDenganMidtrans(int totalHarga) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan");

      final response = await http.post(
        Uri.parse('$baseUrl/midtrans/token'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'total_harga': totalHarga.toString(),
          'nama': _customerData?['name'] ?? '',
          'email': _customerData?['email'] ?? '',
          'no_hp': _customerData?['no_hp'] ?? '',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final snapToken = data['token'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MidtransPaymentScreen(
              snapToken: snapToken,
              onPaymentSuccess: () async {
                await buatPesananSetelahPembayaran();
                
              },
            ),
          ),
        );
      } else {
        throw Exception(data['message'] ?? 'Gagal mendapatkan token Midtrans');
      }
    } catch (e) {
      debugPrint("❌ Error Midtrans: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghubungkan ke Midtrans: $e')),
      );
    }
  }

  // ✅ Fungsi buat pesanan manual (Cash)
  Future<void> _buatPesanan() async {
    if (_selectedDate == null || _selectedTime == null || _selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi tanggal, waktu, dan metode pembayaran!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token tidak ditemukan");

      final jadwalService = DateFormat('yyyy-MM-dd HH:mm:ss').format(
        DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
      );

      final harga = _serviceData?['harga'] ?? 0;

      final response = await http.post(
        Uri.parse('$baseUrl/pemesanan'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'layanan_id': widget.serviceId,
          'jadwal_service': jadwalService,
          'total_harga': harga,
          'metode_pembayaran': _selectedPayment,
        }),
      );

      final data = jsonDecode(response.body);
      debugPrint("📩 Response server: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Pesanan berhasil dibuat')),
        );
        Navigator.pushReplacementNamed(context, '/riwayat-pemesanan');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal membuat pesanan')),
        );
      }
    } catch (e) {
      debugPrint('❌ Error kirim pesanan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final harga = _serviceData?['harga'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🧾 Data Customer
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _customerData == null
                        ? const Text("Data customer tidak ditemukan.")
                        : Text(
                            'Alamat Rumah:\n'
                            '${_customerData!['name']} (${_customerData!['no_hp']})\n'
                            '${_customerData!['alamat']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // 🧹 Layanan yang dipilih
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.imagePath.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: widget.imagePath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: '$imageBaseUrl/${widget.imagePath}',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Harga: Rp ${NumberFormat('#,###', 'id_ID').format(harga)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 📅 Pilih Jadwal
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tanggal Pembersihan',
                          prefixIcon: const Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _pickTime,
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Waktu Pembersihan',
                          prefixIcon: const Icon(Icons.access_time),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: TextEditingController(
                          text: _selectedTime == null
                              ? ''
                              : _selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 💰 Metode Pembayaran
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedPayment = 'Transfer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedPayment == 'Transfer'
                                ? primaryBlue
                                : Colors.grey[300],
                          ),
                          child: Text(
                            'Transfer',
                            style: TextStyle(
                              color: _selectedPayment == 'Transfer'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => setState(() => _selectedPayment = 'Cash'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedPayment == 'Cash'
                                ? primaryBlue
                                : Colors.grey[300],
                          ),
                          child: Text(
                            'Cash',
                            style: TextStyle(
                              color: _selectedPayment == 'Cash'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🚀 Tombol Buat Pesanan
                  ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            if (_selectedPayment == 'Transfer') {
                              final harga = _serviceData?['harga'] ?? 0;
                              await _bayarDenganMidtrans(harga);
                            } else {
                              await _buatPesanan();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Buat Pesanan',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
