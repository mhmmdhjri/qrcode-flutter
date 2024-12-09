import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:qrcode/state_util.dart';
import 'package:qrcode/core.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/ui/home_screen.dart';
import 'package:qrcode/ui/qr_generator_screen.dart';
import 'package:qrcode/ui/qr_scanner_screen.dart';
import 'package:qrcode/ui/splash_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Enable DevicePreview in debug mode
      builder: (context) => const MainApp(), // Wrap your MainApp
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => const SplashScreen(),
        '/Home' : (context) => const HomeScreen(),
        '/Create' : (context) => const QrGeneratorScreen(),
        '/Scan' : (context) => const QrScannerScreen(),
      },
      locale: DevicePreview.locale(context), // Set locale for DevicePreview
      builder: DevicePreview.appBuilder, // Wrap app with DevicePreview builder
    );
  }
}
