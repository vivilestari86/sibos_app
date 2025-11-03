import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransPaymentScreen extends StatefulWidget {
  final String snapToken;
  final Future<void> Function() onPaymentSuccess;

  const MidtransPaymentScreen({
    super.key,
    required this.snapToken,
    required this.onPaymentSuccess,
  });

  @override
  State<MidtransPaymentScreen> createState() => _MidtransPaymentScreenState();
}

class _MidtransPaymentScreenState extends State<MidtransPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isHandled = false; // ✅ mencegah onPaymentSuccess dipanggil dua kali

  @override
  void initState() {
    super.initState();

    final snapUrl =
        "https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (progress == 100) {
              setState(() => _isLoading = false);
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;

            // ✅ Deteksi pembayaran sukses dari Midtrans
            if (!_isHandled &&
                (url.contains('status_code=200') ||
                    url.contains('transaction_status=settlement') ||
                    url.contains('finish'))) {
              _isHandled = true;

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await widget.onPaymentSuccess();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/riwayat-pemesanan');
                }
              });

              return NavigationDecision.prevent;
            }

            // ❌ Pembayaran dibatalkan
            if (url.contains('deny') || url.contains('cancel')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pembayaran dibatalkan oleh pengguna'),
                    backgroundColor: Colors.orange,
                  ),
                );
                Navigator.pop(context);
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint("❌ WebView error: ${error.description}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal memuat halaman pembayaran: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(snapUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Midtrans"),
        backgroundColor: const Color(0xFF1A1AFF),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A1AFF)),
            ),
        ],
      ),
    );
  }
}
