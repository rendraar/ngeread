import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Inisialisasi WebView.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Tindakan saat halaman dimulai dimuat
          },
          onPageFinished: (String url) {
            // Tindakan saat halaman selesai dimuat
          },
          onWebResourceError: (WebResourceError error) {
            // Menangani kesalahan sumber daya web
          },
          onNavigationRequest: (NavigationRequest request) {
            // Mencegah navigasi ke URL tertentu
            if (request.url.startsWith('https')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Memuat URL yang diterima
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
      ),
      body: WebViewWidget(controller: _controller), // Gunakan WebViewWidget
    );
  }
}
