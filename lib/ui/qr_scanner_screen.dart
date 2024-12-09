import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode/ui/smooth_rounded_painter.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates, returnImage: true);
  String? barcodeValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const CustomSnackbar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              _handleQrDetection(capture);
            },
          ),
          Center(
            child: CustomPaint(
              size: Size(
                250,
                250,
              ),
              painter: SmoothRoundedPainter(),
            ),
          ),
          Positioned(
              child: Center(
            child: Text(
              "Point The QR into the BOX",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ))
        ],
      ),
    );
  }

  void _handleQrDetection(BarcodeCapture capture) {
    final Uint8List? image = capture.image;
    final List<Barcode> value = capture.barcodes;

    for (final barcode in value) {
      barcodeValue = barcode.rawValue!;
    }
    if (image != null) {
      _controller.stop(); // Hentikan pemindaian sementara
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("QR Code Detected"),
              const SizedBox(height: 10),
              Image.memory(image),
              Text(barcodeValue!, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              // Tombol tutup
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Tombol Salin
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: barcodeValue!));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.copy),
                        Text("Copy"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _controller.start(); // Mulai pemindaian kembali
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.close),
                        Text("Close"),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }
}

// snackbar kustom untuk informasi tambahan.
class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Scan QR Code",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Place QR code inside the frame to scan. Please avoid shake to get results quickly.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/scan-icon.png',
              width: 220,
              height: 220,
            ),
          ),
        ],
      ),
    );
  }
}
