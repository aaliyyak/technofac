class Fasilitas {
  final String title;
  final String lokasi;
  final String deskripsi;
  final String imagePath;
  final List<String> keywords;

  Fasilitas({
    required this.title,
    required this.lokasi,
    required this.deskripsi,
    required this.imagePath,
    this.keywords = const [],
  });
}
