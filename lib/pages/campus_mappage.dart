import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class KMap extends StatefulWidget {
  final String tujuan;
  final int lantai;
  final String metodeAkses;

  const KMap({
    super.key,
    required this.tujuan,
    required this.lantai,
    required this.metodeAkses,
  });

  @override
  State<KMap> createState() => _KMapState();
}

class _KMapState extends State<KMap> {
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _suarakanPanduan();
  }

  Future<void> _suarakanPanduan() async {
    await tts.setLanguage("id-ID");
    await tts.setSpeechRate(0.5);

    String pesan;

    if (widget.metodeAkses == "Tangga") {
      pesan =
          "Anda memilih menggunakan tangga. Tangga ada di sebelah kiri Anda. Silakan turun ke lantai ${widget.lantai} untuk menuju ${widget.tujuan}.";
    } else {
      pesan =
          "Anda memilih menggunakan lift. Lift berada di dekat lobby. Tekan tombol lantai ${widget.lantai} untuk menuju ${widget.tujuan}.";
    }

    await tts.speak(pesan);
  }

  // Fungsi bantu untuk dapatkan nama file berdasarkan tujuan dan lantai
  String getMapImagePath() {
    String gedung = widget.tujuan.toLowerCase().replaceAll(" ", "_");
    return 'assets/maps/${gedung}_lantai${widget.lantai}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigasi ke ${widget.tujuan}"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Peta ${widget.tujuan} - Lantai ${widget.lantai}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  getMapImagePath(),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text("Peta tidak tersedia."),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Akses: ${widget.metodeAkses}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Icon(
              Icons.navigation,
              size: 40,
              color: Colors.blue.shade700,
            )
          ],
        ),
      ),
    );
  }
}
