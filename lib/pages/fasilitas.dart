import 'package:flutter/material.dart';

class FasilitasKampusPage extends StatelessWidget {
  const FasilitasKampusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fasilitas Kampus UIGM'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FacilityCard(
            title: 'Perpustakaan',
            description:
                'Perpustakaan dengan koleksi buku yang lengkap dan akses e-library.',
            icon: Icons.library_books,
          ),
          FacilityCard(
            title: 'Laboratorium Komputer',
            description:
                'Laboratorium komputer dengan perangkat modern dan koneksi internet cepat.',
            icon: Icons.computer,
          ),
          FacilityCard(
            title: 'Ruang Kelas',
            description: 'Ruang kelas yang nyaman dengan fasilitas multimedia.',
            icon: Icons.class_,
          ),
          FacilityCard(
            title: 'Kantin',
            description:
                'Kantin kampus yang menyediakan berbagai pilihan makanan dan minuman.',
            icon: Icons.restaurant,
          ),
          FacilityCard(
            title: 'Lapangan Olahraga',
            description:
                'Lapangan olahraga untuk mendukung kegiatan ekstrakurikuler.',
            icon: Icons.sports_soccer,
          ),
        ],
      ),
    );
  }
}

class FacilityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FacilityCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, size: 40.0, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}
