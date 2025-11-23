import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

import 'output.dart';

//import 'package:technofac_app/Pages/hasil_page.dart';

class Mic2 extends StatefulWidget {
  const Mic2({super.key});

  @override
  State<Mic2> createState() => _Mic2State();
}

class _Mic2State extends State<Mic2> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) async {
        // ignore: avoid_print
        print('Status: $status');

        if (status == 'done' || status == 'notListening') {
          _stopListening();

          if (_text.trim().isEmpty) {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Suara tidak dikenali"),
                    content: const Text("Apakah Anda ingin mencoba lagi?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startListening();
                        },
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OutputPage(hasilPencarian: _text),
                ),
              ).then((_) {
                // Reset teks setelah kembali dari hasil
                _textController.clear();
                _text = '';
              });
            }
          }
        }
      },
      onError: (error) {
        // ignore: avoid_print
        print('Error: $error');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: ${error.errorMsg}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              _text = result.recognizedWords;
              _textController.text = result.recognizedWords;
            });
          }
        },
        // ignore: deprecated_member_use
        partialResults: true,
        // ignore: deprecated_member_use
        listenMode: stt.ListenMode.confirmation,
        localeId: 'id_ID',
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 2),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mikrofon tidak tersedia.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _stopListening() {
    _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
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
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/7.png',
              width: 60,
              height: 118,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AvatarGlow(
                  animate: _isListening,
                  glowColor: Colors.blue,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: GestureDetector(
                    onTap: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      radius: 50,
                      child: Icon(
                        Icons.mic,
                        color: _isListening ? Colors.blue : Colors.black54,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Tap Mikrofon untuk Berbicara',
                style: GoogleFonts.candal(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.black),
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Hasil ucapan akan muncul di sini...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
