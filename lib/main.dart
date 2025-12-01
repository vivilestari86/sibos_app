import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibos_app/config.dart';

// Screens
import 'package:sibos_app/screens/edit_profil_screen.dart';
import 'package:sibos_app/screens/notification_screen.dart';
import 'package:sibos_app/screens/profil_screen.dart';
import 'package:sibos_app/screens/riwayat_pemesanan_screen.dart';
import 'package:sibos_app/screens/teknisi_form_screen.dart';
import 'package:sibos_app/screens/teknisi_success_screen.dart';
import 'package:sibos_app/screens/teknisi_home_screen.dart';
import 'package:sibos_app/screens/profile_teknisi_screen.dart';
import 'package:sibos_app/screens/edit_profile_teknisi_screen.dart';
import 'package:app_links/app_links.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> buatPesananSetelahPembayaran(
  String? orderId,
  int layananId,
  DateTime jadwal,
  int totalHarga,
) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    debugPrint("⚠️ Token tidak ditemukan, tidak bisa buat pesanan.");
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/pemesanan'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'layanan_id': layananId,
        'jadwal_service': DateFormat('yyyy-MM-dd HH:mm:ss').format(jadwal),
        'total_harga': totalHarga,
        'metode_pembayaran': 'Transfer',
      }),
    );

    debugPrint("📦 Pesanan dibuat setelah pembayaran: ${response.body}");
  } catch (e) {
    debugPrint("❌ Gagal buat pesanan: $e");
  }
}

void initUniLinks() async {
  final appLinks = AppLinks();

  appLinks.uriLinkStream.listen((uri) {
    if (uri.toString() == 'myapp://riwayat-pemesanan') {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => const RiwayatPemesananScreen()),
      );
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib sebelum async
  await initializeDateFormatting('id', null); // Format tanggal Indonesia
  await AppConfig.loadToken(); // 🔥 Load token dari SharedPreferences
  initUniLinks(); // Aktifkan listener deep link

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 🔗 Untuk deep link
      debugShowCheckedModeBanner: false,
      title: 'SIBOS',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/riwayat-pemesanan': (context) => const RiwayatPemesananScreen(),
        '/profil': (context) => const ProfileScreen(),
        '/edit-profil': (context) => const EditProfileScreen(initialData: {}),
        '/teknisi-form': (context) => const TeknisiFormScreen(),
        '/teknisi-success': (context) => const TeknisiSuccessScreen(),
        '/teknisi-home': (context) => const TeknisiHomeScreen(),
        '/profil-teknisi': (context) => const ProfileTeknisiScreen(),
        '/edit-profil-teknisi': (context) => const EditProfileTeknisiScreen(teknisi: {}),

      },
    );
  }
}
