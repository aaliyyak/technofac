import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

import '../data/fasilitas_list.dart';
import '../models/fasilitas_models.dart';
import '../themes/themes.dart';
import 'mic2.dart';
import 'panduan.dart';

class OutputPage extends StatefulWidget {
  final String hasilPencarian;
  const OutputPage({super.key, required this.hasilPencarian});

  @override
  State<OutputPage> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  final FlutterTts flutterTts = FlutterTts();
  Fasilitas? fasilitasDitemukan;
  bool _isLoading = true;
  bool _showMapButton = false;
  double _scale = 1.0;
  bool _isFavorited = false;
  String? kalimatPengguna;

  @override
  void initState() {
    super.initState();
    kalimatPengguna = widget.hasilPencarian;
    _prosesIntent();
  }

  String deteksiIntent(String kalimat) {
    kalimat = kalimat.toLowerCase();
    if (kalimat.contains("navigasi") ||
        kalimat.contains("arah") ||
        kalimat.contains("panduan")) {
      return "navigasi_fasilitas";
    } else if (kalimat.contains("dimana") ||
        kalimat.contains("di mana") ||
        kalimat.contains("letak") ||
        kalimat.contains("cari") ||
        kalimat.contains("carikan") ||
        kalimat.contains("cari lokasi") ||
        kalimat.contains("tunjukkan") ||
        kalimat.contains("lokasi")) {
      return "cari_fasilitas";
    } else {
      return "cari_fasilitas";
    }
  }

  Fasilitas? deteksiEntitas(String input) {
    input = input.toLowerCase();
    for (var fasilitas in fasilitasList) {
      final semuaNama = [
        fasilitas.title.toLowerCase(),
        ...fasilitas.keywords.map((k) => k.toLowerCase())
      ];
      for (var nama in semuaNama) {
        if (input.contains(nama) || nama.contains(input)) {
          return fasilitas;
        }
      }
    }
    return null;
  }

  void _prosesIntent() async {
    setState(() {
      fasilitasDitemukan = null;
      _isLoading = true;
    });

    final input = widget.hasilPencarian.toLowerCase();
    final intent = deteksiIntent(input);
    final fasilitas = deteksiEntitas(input);

    if (fasilitas == null) {
      setState(() {
        fasilitasDitemukan = null;
        _isLoading = false;
      });

      await flutterTts.setLanguage("id-ID");
      await flutterTts.setSpeechRate(0.5);

      Future.delayed(Duration.zero, () {
        Alert(
          context: context,
          type: AlertType.warning,
          style: AlertStyle(
            backgroundColor: Colors.white,
            titleStyle: GoogleFonts.candal(color: Colors.black, fontSize: 18),
            descStyle:
                GoogleFonts.faustina(color: Colors.black87, fontSize: 14),
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.orangeAccent),
            ),
            isOverlayTapDismiss: false,
            animationType: AnimationType.grow,
          ),
          title: "Fasilitas Tidak Ditemukan",
          desc:
              "Kami tidak menemukan \"${widget.hasilPencarian}\". Silakan coba nama fasilitas lain.",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const Mic2()));
              },
              color: Colors.orange,
              child: const Text("OK",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ).show();
      });
      return;
    }

    setState(() {
      fasilitasDitemukan = fasilitas;
      _isLoading = false;
    });

    if (intent == "navigasi_fasilitas" || intent == "cari_fasilitas") {
      await _speakOutput();
    }
  }

  Future<void> _speakOutput() async {
    String sentence =
        "Fasilitas ditemukan, ${fasilitasDitemukan!.title} berada di ${fasilitasDitemukan!.lokasi}, mau dibantu navigasi ke ${fasilitasDitemukan!.title} nggak?";
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(sentence);
    flutterTts.setCompletionHandler(() {
      if (mounted) _showCustomNavigationDialog();
    });
  }

  void _showCustomNavigationDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 16),
            const Icon(Icons.navigation_rounded, color: Colors.blue, size: 40),
            const SizedBox(height: 12),
            Text("Navigasi ke Fasilitas",
                style: GoogleFonts.candal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            Text("Mau dibantu navigasi ke lokasi ini?",
                style:
                    GoogleFonts.faustina(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await flutterTts.stop();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text("Tidak",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _scale = 1.2;
                      _showMapButton = true;
                    });
                    Future.delayed(const Duration(milliseconds: 300),
                        () => setState(() => _scale = 1.0));
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label:
                      const Text("Iya", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Hasil Pencarian", style: blackTextstyle),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () async {
            await flutterTts.stop();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite,
                color: _isFavorited ? Colors.pink : Colors.grey),
            onPressed: () => setState(() => _isFavorited = !_isFavorited),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: _isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.white),
                        const SizedBox(height: 16),
                        Container(height: 20, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.white),
                        const SizedBox(height: 20),
                        Container(height: 20, width: 100, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.white),
                        const SizedBox(height: 20),
                        Container(height: 20, width: 100, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.white),
                      ],
                    ),
                  )
                : fasilitasDitemukan == null
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pencarian:",
                                    style: GoogleFonts.candal(
                                        color: Colors.black, fontSize: 13)),
                                const SizedBox(width: 2),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        kalimatPengguna ?? '',
                                        style: GoogleFonts.candal(
                                          color: Colors.blue,
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const Positioned(
                                      right: 1,
                                      top: 0,
                                      child: Icon(Icons.search,
                                          size: 12, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    fasilitasDitemukan!.imagePath,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: InteractiveViewer(
                                              child: Image.asset(
                                                  fasilitasDitemukan!
                                                      .imagePath),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54,
                                      ),
                                      child: const Icon(Icons.zoom_out_map,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Nama',
                                style: GoogleFonts.candal(
                                    fontSize: 18, color: Colors.black)),
                            const SizedBox(height: 8),
                            Text(fasilitasDitemukan!.title,
                                style: GoogleFonts.faustina(
                                    fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 20),
                            Text('Lokasi',
                                style: GoogleFonts.candal(
                                    fontSize: 18, color: Colors.black)),
                            const SizedBox(height: 8),
                            Text(fasilitasDitemukan!.lokasi,
                                style: GoogleFonts.faustina(
                                    fontSize: 16, color: Colors.black)),
                            const SizedBox(height: 20),
                            Text('Deskripsi',
                                style: GoogleFonts.candal(
                                    fontSize: 18, color: Colors.black)),
                            const SizedBox(height: 8),
                            Text(fasilitasDitemukan!.deskripsi,
                                style: GoogleFonts.faustina(
                                    fontSize: 15, color: Colors.black),
                                textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
          ),
          if (_showMapButton)
            Positioned(
              bottom: 10,
              left: 20,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 300),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const NavigationPage(lokasiTujuan: ''))),
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 230,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Panduan Navigasi",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'mic',
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Mic2())),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
