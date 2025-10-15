import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sibos_app/screens/service_detail_screen.dart';
import 'package:sibos_app/services/layanan_service.dart';
import 'package:sibos_app/config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredServices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLayanan();
  }

  Future<void> _fetchLayanan({String? query}) async {
    setState(() {
      _loading = true;
    });
    final result = await LayananService.fetchLayanan(search: query);
    setState(() {
      _filteredServices = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              color: Color(0xFF1A1AFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.search, color: Colors.white, size: 30),
                      ],
                    ),
                    Spacer(),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Cari Layanan yang Kamu Butuhkan",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Temukan layanan rumah tangga terbaik di sini",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                _fetchLayanan(query: val);
              },
              decoration: InputDecoration(
                hintText: "Cari berdasarkan jenis layanan...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _fetchLayanan(query: "");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredServices.isEmpty
                      ? const Center(child: Text("Layanan tidak ditemukan"))
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                          itemCount: _filteredServices.length,
                          itemBuilder: (context, index) {
                            final item = _filteredServices[index];
                            return _serviceCard(
                              context: context,
                              id: item['id'],
                              title: item['jenis_layanan'] ?? '-',
                              imagePath: item['gambar'] ?? 'assets/images/default.jpg',
                              description: item['deskripsi'] ?? '',
                              harga: item['harga'] ?? 0,
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard({
    required BuildContext context,
    required int id,
    required String title,
    required String imagePath,
    required String description,
    required int harga,
  }) {
    Widget imageWidget;

    if (imagePath.startsWith('http')) {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: CachedNetworkImage(
          imageUrl: imagePath,
          fit: BoxFit.cover,
          placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
          errorWidget: (c, s, e) =>
              Image.asset('assets/images/default.jpg', fit: BoxFit.cover),
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network('${AppConfig.baseUrl.replaceFirst("/api", "")}/storage/$imagePath',
            fit: BoxFit.cover, errorBuilder: (c, e, s) {
          return Image.asset('assets/images/default.jpg', fit: BoxFit.cover);
        }),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(
              serviceId: id,
              title: title,
              description: description,
              imagePath: imagePath.startsWith('http')
                  ? imagePath
                  : '${AppConfig.baseUrl.replaceFirst("/api", "")}/storage/$imagePath',
              harga: harga,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: imageWidget),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF1A1AFF),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
