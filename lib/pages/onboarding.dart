import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'homepages.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  // Fungsi inisialisasi TTS saat halaman dibuka
  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage('id-ID');
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.awaitSpeakCompletion(true); // menunggu sampai selesai

      setState(() {
        _isSpeaking = true;
      });

      // Mulai berbicara
      await _flutterTts.speak('Hai, Selamat Datang di Technofac!');

      // Set state untuk menunjukkan bahwa TTS sudah selesai
      setState(() {
        _isSpeaking = false;
      });
    } catch (e) {
      // ignore: avoid_print
      print("TTS Error: $e");
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  @override
  void dispose() {
    if (_isSpeaking) {
      _flutterTts.stop(); // Hentikan suara saat keluar dari halaman
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/z.png',
                height: 320,
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Text(
                    'Hai, Selamat Datang',
                    style: GoogleFonts.candal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'di Technofac!',
                    style: GoogleFonts.candal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    'Tecnofac adalah voice asisten berbasis ',
                    style: GoogleFonts.faustina(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Android yang dapat membantu kamu dalam mencari berbagai fasilitas kampus di Universitas IGM.',
                    style: GoogleFonts.faustina(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  // Pastikan suara dihentikan sebelum pindah halaman
                  if (_isSpeaking) {
                    await _flutterTts.stop();
                  }
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009CCF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Let\'s Go',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
