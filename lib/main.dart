import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ Tambahkan ini!
import 'package:sibos_app/screens/chat_screen.dart';
import 'package:sibos_app/screens/edit_profil_screen.dart';
import 'package:sibos_app/screens/notification_screen.dart';
import 'package:sibos_app/screens/profil_screen.dart';
import 'package:sibos_app/screens/riwayat_pemesanan_screen.dart';
import 'package:sibos_app/screens/teknisi_form_screen.dart';
import 'package:sibos_app/screens/teknisi_home_screen.dart';
import 'package:sibos_app/screens/teknisi_success_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Penting untuk async init
  await initializeDateFormatting('id', null); // ✅ Inisialisasi format tanggal lokal (Indonesia)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIBOS',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        "/notifications": (context) => const NotificationScreen(),
        '/riwayat-pemesanan': (context) => const RiwayatPemesananScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profil': (context) => const ProfileScreen(),
        '/edit-profil': (context) => const EditProfileScreen(),
        '/teknisi-form': (context) => const TeknisiFormScreen(),
        '/teknisi-success': (context) => const TeknisiSuccessScreen(),
        '/teknisi-home': (context) => const TeknisiHomeScreen(),
      },
    );
  }
}
