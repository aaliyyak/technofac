import 'package:flutter/material.dart';

class SejarahPage extends StatelessWidget {
  const SejarahPage({super.key});

  // Widget bubble paragraf
  Widget bubbleText(String text, {bool isSender = false}) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? Colors.white : Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: isSender
              ? const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(0),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(35),
                ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Sejarah Kampus UIGM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bubble 1 (kiri)
              bubbleText(
                'Universitas Indo Global Mandiri (UIGM) didirikan berdasarkan Keputusan Menteri Pendidikan Nasional Republik Indonesia nomor 83/D/O/2008 tanggal 22 Mei 2008, hasil dari merger antara Sekolah Tinggi Manajemen Informatika & Komputer (STMIK) IGM dengan Sekolah Tinggi Teknologi Palembang (STTP) IGM.',
                isSender: false,
              ),

              // Bubble 2 (kanan)
              bubbleText(
                'Pada awalnya UIGM terdiri dari 3 Fakultas, yaitu:\n\n'
                '• Fakultas Ilmu Komputer terdiri dari Program Studi Teknik Informatika (S1), Sistem Informasi (S1), Teknik Komputer (D3), Manajemen Informatika (D3), Komputerisasi Akuntansi (D3). Saat ini Program Studi Teknik Komputer ditingkatkan dari D3 menjadi S1 Sistem Komputer, sedangkan untuk Komputerisasi Akuntansi tidak dilanjutkan, menyesuaikan dengan kebutuhan pasar.\n\n'
                '• Fakultas Teknik terdiri dari Program Studi Teknik Sipil (S1), Teknik Arsitektur (S1), Perencanaan Wilayah dan Kota (S1), Survei dan Pemetaan (D3).\n\n'
                '• Fakultas Ekonomi terdiri dari Program Studi Manajemen (S1) dan Akuntansi (S1).',
                isSender: true,
              ),

              // Bubble 3 (kiri)
              bubbleText(
                'Dengan berjalannya waktu, untuk memenuhi permintaan pasar, secara bertahap dikembangkan beberapa Program Studi yang tergabung dalam 2 Fakultas, yaitu:\n\n'
                '• Fakultas Ilmu Pemerintahan dan Budaya, terdiri dari Program Studi Ilmu Pemerintahan dan Desain Komunikasi Visual (DKV).\n\n'
                '• Fakultas Keguruan dan Ilmu Pendidikan yang terdiri dari Program Studi Bahasa Inggris dan Matematika. Untuk sementara Program Studi Matematika belum dijalankan mengingat keterbatasan minat dari masyarakat.',
                isSender: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
