import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfWebViewScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfWebViewScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfWebViewScreenState createState() => _PdfWebViewScreenState();
}

class _PdfWebViewScreenState extends State<PdfWebViewScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }

  void _loadHtmlFromAssets() {
    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body>
        <iframe 
          src="${widget.pdfUrl}" 
          width="100%" 
          height="100%" 
          style="border: none;">
        </iframe>
      </body>
      </html>
    ''';

    _controller.loadHtmlString(htmlContent);
  }
}
