import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'panduan.dart';
import 'splash.dart';
import 'spot_rekomendasi_page.dart';
import 'uigmabout.dart';
import 'voice_input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage('id-ID');
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(1.0);
    _playWelcomeMessage();
  }

  Future<void> _playWelcomeMessage() async {
    await _flutterTts.speak('Kamu mau cari apa?');
  }

  // ============================
  //   FUNGSI LOGOUT
  // ============================
  Future<void> _logout(BuildContext context) async {
    await _flutterTts.stop();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================
      //   APPBAR + LOGOUT BUTTON
      // ============================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _logout(context),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 5),

          // Logo
          Column(
            children: [
              Image.asset(
                'assets/g2.png',
                width: 140,
                height: 50,
              ),
              const SizedBox(height: 20),
            ],
          ),

          // Judul
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(70),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(70),
              ),
            ),
            child: Center(
              child: Text(
                'Kamu mau cari apa?',
                style: GoogleFonts.candal(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Grid menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.65,
                children: [
                  buildMenuCard(
                    'Tentang UIGM',
                    'assets/uiv2.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UIGMPage()),
                      );
                    },
                  ),
                  buildMenuCard(
                    'Cari Fasilitas',
                    'assets/o31.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VoiceInputPage()),
                      );
                    },
                  ),
                  buildMenuCard(
                    'Rekomendasi Spot Favorit ',
                    'assets/s2.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SpotRekomendasiPage()),
                      );
                    },
                  ),
                  buildMenuCard(
                    'Panduan',
                    'assets/p1.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const NavigationPage(lokasiTujuan: '')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card Menu
  Widget buildMenuCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 243,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.candal(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
