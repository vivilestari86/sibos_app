import 'package:flutter/material.dart';

class DetailPemesananScreen extends StatefulWidget {
  final String serviceTitle;
  final String imagePath;

  const DetailPemesananScreen({
    super.key,
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

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      helpText: 'Pilih Tanggal Pembersihan',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Pilih Waktu Pembersihan',
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF1A1AFF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Alamat Rumah
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Alamat Rumah:\nVivi Lestari (0812-8082-3794)\n'
                'Blok Kali Kulon, RT 014 / RW 007, Desa Druntenwetan, '
                'Kec. Gabuswetan, Kab. Indramayu',
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Card Service & Harga
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar layanan
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Rincian harga
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
                        const Text('Rincian Harga:', style: TextStyle(fontSize: 14)),
                        const Text('• Jasa Layanan: Rp 200.000'),
                        const Text('• Biaya Transportasi: Rp 20.000'),
                        const SizedBox(height: 4),
                        const Text(
                          'TOTAL: Rp 220.000',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Jadwal dan Waktu
            GestureDetector(
              onTap: _pickDate,
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Jadwal Pembersihan',
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
                        : '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickTime,
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
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

            // Metode Pembayaran
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedPayment = 'Transfer';
                      });
                    },
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
                    onPressed: () {
                      setState(() {
                        _selectedPayment = 'Cash';
                      });
                    },
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

            // Tombol Buat Pesanan
            ElevatedButton(
              onPressed: () {
                if (_selectedDate == null || _selectedTime == null || _selectedPayment == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lengkapi tanggal, waktu, dan metode pembayaran!'),
                    ),
                  );
                  return;
                }

                // Arahkan ke halaman Riwayat Pemesanan
                Navigator.pushReplacementNamed(context, '/riwayat');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
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
