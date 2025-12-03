import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class KMap extends StatefulWidget {
  final String tujuan;
  final int lantai;
  final String metodeAkses;
  final Offset posisiAwal; // Offset dari posisi saat ini

  const KMap({
    super.key,
    required this.tujuan,
    required this.lantai,
    required this.metodeAkses,
    required this.posisiAwal,
  });

  @override
  State<KMap> createState() => _KMapState();
}

class _KMapState extends State<KMap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final FlutterTts flutterTts = FlutterTts();
  bool suaraAktif = true;

  final TransformationController _transformationController =
      TransformationController();

  // Koordinat posisi tujuan di peta
  final Map<String, Offset> posisiGedung = {
    'Gedung L': const Offset(400, 1050),
    'Gedung B': const Offset(450, 750),
    'Gedung C': const Offset(690, 500),
    'Fakultas Kedokteran': const Offset(850, 700),
    'Gedung PASCA': const Offset(180, 430),
    'Lab. Anatomi': const Offset(350, 410),
    'ATM Center': const Offset(940, 1050),
    'Rumah Saya': const Offset(400, 1400),
  };

  Offset posisiTujuan = Offset.zero;
  late Offset posisiSaatIni;

  @override
  void initState() {
    super.initState();

    // Ambil posisi dari parameter
    posisiSaatIni = widget.posisiAwal;

    // Inisialisasi animasi untuk posisi saat ini
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 12.0, end: 28.0).animate(_controller);

    // Ambil posisi tujuan berdasarkan gedung
    posisiTujuan = posisiGedung[widget.tujuan] ?? const Offset(250, 250);

    // Panduan suara jika aktif
    if (suaraAktif) _speakPanduan();
  }

  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakPanduan() async {
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak("Anda sedang menuju ${widget.tujuan}");
  }

  Widget _buildTujuanMarker() {
    return Positioned(
      left: posisiTujuan.dx,
      top: posisiTujuan.dy,
      child: const Icon(Icons.location_on, size: 44, color: Colors.red),
    );
  }

  Widget _buildPosisiSaya() {
    return Positioned(
      left: posisiSaatIni.dx,
      top: posisiSaatIni.dy,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKompas() {
    return Positioned(
      top: 16,
      right: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 3)
              ],
            ),
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: CustomPaint(
              painter: _CrossLinePainter(),
            ),
          ),
          const Icon(Icons.arrow_drop_up,
              size: 30, color: Colors.black), // tanpa rotasi
          const Positioned(
              top: 4,
              child: Text('U',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          const Positioned(
              bottom: 4,
              child: Text('S',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          const Positioned(
              left: 4,
              child: Text('B',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          const Positioned(
              right: 4,
              child: Text('T',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildVoiceButton() {
    return Positioned(
      top: 130,
      right: 20,
      child: FloatingActionButton(
        heroTag: 'suara',
        backgroundColor: suaraAktif ? Colors.blue : Colors.grey.shade300,
        onPressed: () {
          setState(() {
            suaraAktif = !suaraAktif;
          });
          if (suaraAktif) {
            _speakPanduan();
          } else {
            flutterTts.stop();
          }
        },
        child: Icon(
          suaraAktif ? Icons.volume_up : Icons.volume_off,
          color: suaraAktif ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        heroTag: 'pusatkan',
        onPressed: () {
          _transformationController.value = Matrix4.identity()
            ..translate(-posisiSaatIni.dx + 150, -posisiSaatIni.dy + 300);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peta Kampus: ${widget.tujuan}'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 5.0,
            constrained: false,
            child: Stack(
              children: [
                Image.asset(
                  'assets/MP.png',
                  fit: BoxFit.none,
                ),
                _buildTujuanMarker(),
                _buildPosisiSaya(),
              ],
            ),
          ),
          _buildKompas(),
          _buildVoiceButton(),
          _buildCenterButton(),
        ],
      ),
    );
  }
}

class _CrossLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    canvas.drawLine(Offset(centerX, 0), Offset(centerX, size.height), paint);
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
