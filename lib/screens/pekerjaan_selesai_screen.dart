import 'package:flutter/material.dart';

class PekerjaanSelesaiScreen extends StatelessWidget {
  const PekerjaanSelesaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Pekerjaan Selesai",
          style: TextStyle(
            color: Color(0xFF1A1AFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1AFF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified, color: Color(0xFF10B981), size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    "4 Pekerjaan Selesai",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Riwayat pekerjaan yang telah diselesaikan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // List Pekerjaan
            _buildJobCard(
              "Service AC Split",
              "Budi Santoso",
              "Jl. Merdeka No. 123, Jakarta",
              "0812-3456-7890",
              "16-09-2025",
              "Rp 220.000",
            ),
            _buildJobCard(
              "Service Kulkas 2 Pintu",
              "Siti Aminah",
              "Jl. Sudirman No. 456, Jakarta",
              "0813-4567-8901",
              "15-09-2025",
              "Rp 135.000",
            ),
            _buildJobCard(
              "Instalasi Listrik",
              "Ahmad Rizki",
              "Jl. Thamrin No. 789, Jakarta",
              "0814-5678-9012",
              "14-09-2025",
              "Rp 180.000",
            ),
            _buildJobCard(
              "Service TV LED",
              "Maya Sari",
              "Jl. Gatot Subroto No. 321, Jakarta",
              "0815-6789-0123",
              "13-09-2025",
              "Rp 150.000",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(
    String service,
    String customerName,
    String address,
    String phone,
    String date,
    String income,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan service dan status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Customer
          _buildInfoRow(Icons.person, "Customer", customerName),
          _buildInfoRow(Icons.location_on, "Alamat", address),
          _buildInfoRow(Icons.phone, "Telepon", phone),
          _buildInfoRow(Icons.calendar_today, "Tanggal", date),
          
          const SizedBox(height: 16),

          // Income Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pendapatan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Pekerjaan telah dibayar",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  income,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Rating Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFA000).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFA000).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFA000), size: 20),
                const SizedBox(width: 8),
                const Text(
                  "4.8",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "(5 rating)",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Ulasan Positif",
                    style: TextStyle(
                      color: Color(0xFFFFA000),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}