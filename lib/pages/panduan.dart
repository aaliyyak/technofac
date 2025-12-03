// Tetap import seperti biasa
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/wifi_position_model.dart';
import 'campus_mappage.dart';

class NavigationPage extends StatefulWidget {
  final String lokasiTujuan;

  const NavigationPage({super.key, required this.lokasiTujuan});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  String posisiSaatIni = 'Sedang mendeteksi...';
  String gedungTujuan = '';

  final List<String> daftarGedung = [
    'Gedung L',
    'Gedung B',
    'Gedung C',
    'Fakultas Kedokteran',
    'Gedung PASCA',
    'Rumah Saya',
    'Rumah Putri',
    'Lab. Anatomi',
    'ATM Center',
  ];

  String selectedGedung = '';
  TextEditingController tujuanController = TextEditingController();
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    selectedGedung = widget.lokasiTujuan;
    tujuanController.text = widget.lokasiTujuan;
    gedungTujuan = widget.lokasiTujuan;
    _suarakan("Sedang mendeteksi lokasi anda...");
    _ambilPosisiDariWifi();
  }

  Future<void> _suarakan(String text) async {
    await tts.setLanguage("id-ID");
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  Future<void> _ambilPosisiDariWifi() async {
    setState(() => posisiSaatIni = 'Sedang mendeteksi...');

    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) {
      if (mounted) setState(() => posisiSaatIni = 'Izin lokasi ditolak');
      return;
    }

    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      if (mounted) setState(() => posisiSaatIni = 'Nyalakan GPS di perangkat');
      return;
    }

    final canStart = await WiFiScan.instance.canStartScan();
    if (canStart != CanStartScan.yes) {
      if (mounted) {
        setState(() => posisiSaatIni =
            'Tidak bisa memulai scan Wi-Fi. Pastikan izin lokasi aktif dan Wi-Fi menyala.');
      }
      return;
    }

    try {
      await WiFiScan.instance.startScan();
      final hasil = await WiFiScan.instance.getScannedResults();

      final wifiTerdekat = hasil.firstWhere(
        (wifi) =>
            wifi.ssid.trim().isNotEmpty &&
            !wifi.ssid.toLowerCase().contains("nvram warning"),
        orElse: () => hasil.first,
      );

      final model = WifiPositionModel(
        ssid: wifiTerdekat.ssid.trim(),
        rssi: wifiTerdekat.level,
      );

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final lokasi = model.getLokasi();
        setState(() => posisiSaatIni = lokasi);
        _suarakan("Lokasi ditemukan. Saat ini Anda berada di $lokasi");
      }
    } catch (e) {
      if (mounted) setState(() => posisiSaatIni = 'Gagal mendeteksi Wi-Fi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Panduan Navigasi',
            style: GoogleFonts.candal(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBoxWithRefresh(
              icon: Icons.my_location,
              title: "Posisi Saat Ini",
              value: posisiSaatIni,
              color: Colors.blue,
              bgColor: Colors.blue.shade50,
              onRefresh: _ambilPosisiDariWifi,
            ),
            const SizedBox(height: 20),
            _buildGedungDropdown(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.directions_walk),
              label: const Text("Mulai Navigasi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: gedungTujuan.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KMap(
                            tujuan: gedungTujuan,
                            lantai: 1, // default lantai 1
                            metodeAkses: 'default',
                            posisiAwal: const Offset(0, 0),
                          ),
                        ),
                      );
                    },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGedungDropdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_city, color: Colors.blue, size: 28),
              const SizedBox(width: 10),
              Text("Pilih Gedung Tujuan",
                  style: GoogleFonts.candal(fontSize: 16, color: Colors.black)),
              const Spacer(),
              if (selectedGedung.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      selectedGedung = '';
                      tujuanController.clear();
                      gedungTujuan = '';
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedGedung.isNotEmpty ? selectedGedung : null,
            hint: const Text("Pilih Gedung"),
            dropdownColor: Colors.white,
            items: daftarGedung.map((gedung) {
              return DropdownMenuItem<String>(
                value: gedung,
                child:
                    Text(gedung, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedGedung = value;
                  tujuanController.text = value;
                  gedungTujuan = value;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: tujuanController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: "Atau Ketik Nama Gedung Tujuan",
              labelStyle: const TextStyle(color: Colors.black54),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (value) => setState(() => gedungTujuan = value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBoxWithRefresh({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
    required VoidCallback onRefresh,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        GoogleFonts.candal(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.faustina(
                        fontSize: 15, color: Colors.black)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            tooltip: 'Deteksi ulang lokasi',
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
