class AppConfig {
  // Ganti sesuai IP komputer kamu (hasil dari "ipconfig" di CMD)

  static const String baseUrl = "http://192.168.1.104:8000/api";

  // Kalau kamu juga sering akses gambar dari Laravel storage:
  static const String imageBaseUrl = "http://192.168.1.104:8000/storage";
}
