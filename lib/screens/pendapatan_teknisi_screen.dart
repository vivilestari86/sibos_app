import 'package:flutter/material.dart';

class PendapatanTeknisiScreen extends StatelessWidget {
  const PendapatanTeknisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pendapatan Teknisi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1AFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Arahkan ke home_screen.dart
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Box Total Pendapatan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1AFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Text(
                    "Total Pendapatan Bulan Ini",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Rp 1.355.000",
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

            // Filter & Tabel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF1A1AFF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Filter Berdasarkan Bulan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1AFF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Tampilkan"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tabel dummy
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FixedColumnWidth(30),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                      4: FlexColumnWidth(),
                    },
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: Color(0xFFEAEAFF)),
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text("No")),
                          Padding(padding: EdgeInsets.all(8), child: Text("Nama")),
                          Padding(padding: EdgeInsets.all(8), child: Text("Tanggal")),
                          Padding(padding: EdgeInsets.all(8), child: Text("Status")),
                          Padding(padding: EdgeInsets.all(8), child: Text("Total")),
                        ],
                      ),
                      // Data kosong sementara
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
