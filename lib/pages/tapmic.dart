// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'voice_input_page.dart';

class TapMicPage extends StatelessWidget {
  const TapMicPage({super.key});

  // Fungsi untuk meminta izin mikrofon
  Future<void> _mintaIzinMic(BuildContext context) async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      _tampilkanSnackbar(
        context,
        'Izin mikrofon sudah diberikan',
        Colors.green,
        Icons.check_circle,
      );

      // Navigasi ke halaman voice input
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VoiceInputPage()),
      );
    } else {
      var result = await Permission.microphone.request();

      if (result.isGranted) {
        _tampilkanSnackbar(
          context,
          'Izin mikrofon diberikan',
          Colors.green,
          Icons.check_circle,
        );

        // Navigasi ke halaman voice input
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VoiceInputPage()),
        );
      } else if (result.isDenied) {
        _tampilkanSnackbar(
          context,
          'Izin mikrofon ditolak',
          Colors.red,
          Icons.error,
        );
      } else if (result.isPermanentlyDenied) {
        _tampilkanSnackbar(
          context,
          'Izin ditolak permanen, buka pengaturan aplikasi',
          Colors.orange,
          Icons.warning,
        );
        await openAppSettings();
      }
    }
  }

  // Fungsi untuk menampilkan snackbar dengan style custom
  void _tampilkanSnackbar(
      BuildContext context, String message, Color bgColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 5,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/g2.png',
                width: 150,
                height: 100,
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/7.png',
              width: 60,
              height: 118,
            ),
          ),
          // Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Gambar mikrofon

                Text(
                  'Tap Mikrofon untuk Berbicara',
                  style: GoogleFonts.candal(
                    fontSize: 14,
                    color: Colors.black87,
                    //fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _mintaIzinMic(context),
                  child: Image.asset(
                    'assets/speech2.png', // Gambar mic diam
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
