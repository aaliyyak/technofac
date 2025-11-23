// NavigationPage.dart

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
  int? lantaiTerpilih;
  List<int> daftarLantai = [];
  String? metodeAkses;

  final Map<String, int> gedungDanLantai = {
    'Gedung L': 3,
    'Gedung B': 10,
    'Gedung C': 12,
    'Fakultas Kedokteran': 5,
    'Pascasarjana': 3,
    'Rumah Saya': 1,
    'Rumah Putri': 1,
  };

  String selectedGedung = '';
  TextEditingController tujuanController = TextEditingController();
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    selectedGedung = widget.lokasiTujuan;
    tujuanController.text = widget.lokasiTujuan;
    _aturGedungTujuan(widget.lokasiTujuan);
    _suarakan("Sedang mendeteksi lokasi anda...");
    _ambilPosisiDariWifi();
  }

  Future<void> _suarakan(String text) async {
    await tts.setLanguage("id-ID");
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  void _aturGedungTujuan(String namaGedung) {
    gedungDanLantai.forEach((gedung, jumlahLantai) {
      if (namaGedung.toLowerCase().contains(gedung.toLowerCase())) {
        setState(() {
          gedungTujuan = gedung;
          daftarLantai = List.generate(jumlahLantai, (index) => index + 1);
          lantaiTerpilih = null;
          metodeAkses = null;
        });
      }
    });
  }

  Future<void> _ambilPosisiDariWifi() async {
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

    final CanStartScan canStart = await WiFiScan.instance.canStartScan();
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

      if (hasil.isEmpty) {
        if (mounted) {
          setState(() => posisiSaatIni = 'Tidak ada Wi-Fi terdeteksi');
        }
        return;
      }

      final wifiTerdekat = hasil.first;
      final model = WifiPositionModel(
        ssid: wifiTerdekat.ssid,
        rssi: wifiTerdekat.level,
      );

      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        setState(() => posisiSaatIni = model.getLokasi());
        _suarakan(
            "Lokasi ditemukan. Saat ini Anda berada di ${model.getLokasi()}");
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
            _buildInfoBox(
              icon: Icons.my_location,
              title: "Posisi Saat Ini",
              value: posisiSaatIni,
              color: Colors.blue,
              bgColor: Colors.blue.shade50,
            ),
            const SizedBox(height: 20),

            // Pilih Gedung Tujuan
            _buildGedungDropdown(),

            const SizedBox(height: 20),

            if (gedungTujuan.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.stairs, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text("Pilih Lantai $gedungTujuan",
                      style: GoogleFonts.candal(
                          fontSize: 16, color: Colors.black)),
                ],
              ),
              const SizedBox(height: 12),

              // Dropdown Pilih Lantai
              DropdownButtonFormField<int>(
                value: lantaiTerpilih,
                hint: const Text("Pilih Lantai"),
                dropdownColor: Colors.white,
                items: daftarLantai.map((lantai) {
                  return DropdownMenuItem<int>(
                    value: lantai,
                    child: Text("Lantai $lantai",
                        style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => lantaiTerpilih = value);
                  _suarakan("Lantai $value dipilih");
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

              const SizedBox(height: 20),

              _buildInfoBoxCustom(
                icon: Icons.swap_vert_circle_outlined,
                title: "Pilih Metode Akses Lantai",
                content: Column(
                  children: [
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Row(
                        children: [
                          Icon(Icons.directions_walk, color: Colors.green),
                          SizedBox(width: 6), // Jarak antara ikon dan teks
                          Text("Tangga", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      value: "Tangga",
                      groupValue: metodeAkses,
                      onChanged: (value) {
                        setState(() => metodeAkses = value);
                        _suarakan("Anda memilih menggunakan tangga");
                      },
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Row(
                        children: [
                          Icon(Icons.elevator, color: Colors.blue),
                          SizedBox(width: 6),
                          Text("Lift", style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      value: "Lift",
                      groupValue: metodeAkses,
                      onChanged: (value) {
                        setState(() => metodeAkses = value);
                        _suarakan("Anda memilih menggunakan lift");
                      },
                    ),
                  ],
                ),
              ),
            ],
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
              label: const Text("Mulai Navigasi Indoor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700, // warna aktif
                // disabledBackgroundColor: Colors.blue.shade100, // warna saat disabled
                foregroundColor: Colors.white, // warna teks saat aktif
                disabledForegroundColor:
                    Colors.white, // warna teks saat disabled
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: (gedungTujuan.isEmpty ||
                      lantaiTerpilih == null ||
                      metodeAkses == null)
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KMap(
                            tujuan: gedungTujuan,
                            lantai: lantaiTerpilih!,
                            metodeAkses: '',
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
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
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
                      daftarLantai.clear();
                      lantaiTerpilih = null;
                      metodeAkses = null;
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
            items: gedungDanLantai.keys.map((String gedung) {
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
                  _aturGedungTujuan(value);
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
            onChanged: (value) => _aturGedungTujuan(value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
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
        ],
      ),
    );
  }

  Widget _buildInfoBoxCustom({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style:
                        GoogleFonts.candal(fontSize: 16, color: Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }
}

class LatLng {
  final double lat;
  final double lng;
  LatLng(this.lat, this.lng);
}
