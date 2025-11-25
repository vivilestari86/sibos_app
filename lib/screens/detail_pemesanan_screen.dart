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
  final primaryGradient = const [Color(0xFF1A1AFF), Color(0xFF6366F1)];

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

  Future<bool> cekTeknisiTersedia() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cek-teknisi'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode({
          'layanan_id': widget.serviceId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['available'] == true) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Teknisi tidak tersedia'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengecek teknisi: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return false;
    }
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
        SnackBar(
          content: Text('Gagal menghubungkan ke Midtrans: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ✅ Fungsi buat pesanan manual (Cash)
  Future<void> _buatPesanan() async {
    if (_selectedDate == null || _selectedTime == null || _selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lengkapi tanggal, waktu, dan metode pembayaran!'),
          backgroundColor: Colors.orange[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
          SnackBar(
            content: Text(data['message'] ?? 'Pesanan berhasil dibuat'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pushReplacementNamed(context, '/riwayat-pemesanan');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Gagal membuat pesanan'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error kirim pesanan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final harga = _serviceData?['harga'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A1AFF)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 👤 Data Customer Card
                  _buildSectionCard(
                    title: "Data Customer",
                    icon: Icons.person_outline,
                    child: _customerData == null
                        ? const Text(
                            "Data customer tidak ditemukan.",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(Icons.person, "Nama", _customerData!['name'] ?? '-'),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.phone, "No. HP", _customerData!['no_hp'] ?? '-'),
                              const SizedBox(height: 8),
                              _buildInfoRow(Icons.location_on, "Alamat", _customerData!['alamat'] ?? '-', isMultiLine: true),
                            ],
                          ),
                  ),
                  const SizedBox(height: 20),

                  // 🧹 Layanan yang dipilih Card
                  _buildSectionCard(
                    title: "Layanan Dipilih",
                    icon: Icons.cleaning_services_outlined,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Layanan
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
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
                                    errorWidget: (context, url, error) => 
                                      const Icon(Icons.cleaning_services, color: Colors.grey),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Detail Layanan
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: primaryGradient),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Rp ${NumberFormat('#,###', 'id_ID').format(harga)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 📅 Jadwal Pembersihan Card
                  _buildSectionCard(
                    title: "Jadwal Pembersihan",
                    icon: Icons.calendar_today_outlined,
                    child: Column(
                      children: [
                        _buildDateTimeField(
                          icon: Icons.calendar_today,
                          label: "Tanggal Pembersihan",
                          value: _selectedDate == null
                              ? null
                              : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 16),
                        _buildDateTimeField(
                          icon: Icons.access_time,
                          label: "Waktu Pembersihan",
                          value: _selectedTime?.format(context),
                          onTap: _pickTime,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 💰 Metode Pembayaran Card
                  _buildSectionCard(
                    title: "Metode Pembayaran",
                    icon: Icons.payment_outlined,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildPaymentOption(
                                title: 'Transfer',
                                icon: Icons.credit_card,
                                isSelected: _selectedPayment == 'Transfer',
                                onTap: () => setState(() => _selectedPayment = 'Transfer'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPaymentOption(
                                title: 'Cash',
                                icon: Icons.money,
                                isSelected: _selectedPayment == 'Cash',
                                onTap: () => setState(() => _selectedPayment = 'Cash'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_selectedPayment != null)
                          Text(
                            _selectedPayment == 'Transfer' 
                                ? 'Pembayaran akan diproses via Midtrans'
                                : 'Bayar langsung saat teknisi datang',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🚀 Tombol Buat Pesanan
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: primaryGradient),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              bool tersedia = await cekTeknisiTersedia();
                              if (!tersedia) return;

                              if (_selectedPayment == 'Transfer') {
                                final harga = _serviceData?['harga'] ?? 0;
                                await _bayarDenganMidtrans(harga);
                              } else {
                                await _buatPesanan();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                SizedBox(width: 8),
                                Text(
                                  'Memproses...',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_checkout, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Buat Pesanan',
                                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // 🔹 Widget untuk section card
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
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
                    color: primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1AFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Content
            child,
          ],
        ),
      ),
    );
  }

  // 🔹 Widget untuk baris informasi
  Widget _buildInfoRow(IconData icon, String label, String value, {bool isMultiLine = false}) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: isMultiLine ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 Widget untuk field tanggal/waktu
  Widget _buildDateTimeField({
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value == null ? Colors.grey[300]! : primaryBlue,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value ?? 'Pilih $label',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: value == null ? Colors.grey[400] : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: value == null ? Colors.grey[400] : primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Widget untuk opsi pembayaran
  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? primaryBlue : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? primaryBlue : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}