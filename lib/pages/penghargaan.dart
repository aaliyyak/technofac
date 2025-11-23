import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class PenghargaanPage extends StatefulWidget {
  const PenghargaanPage({super.key});

  @override
  State<PenghargaanPage> createState() => _PenghargaanPageState();
}

class _PenghargaanPageState extends State<PenghargaanPage> {
  final List<Map<String, String>> sliderItems = [
    {'image': 'assets/reward/Andina.jpeg', 'title': 'Kampus Terbaik'},
    {'image': 'assets/reward/akreditasi.png', 'title': 'Penghargaan Inovasi'},
    {'image': 'assets/reward/q.png', 'title': 'Motto Universitas'},
  ];

  final List<Map<String, String>> gridItems = [
    {'image': 'assets/reward/akreditasi.png', 'title': 'Kampus Terbaik'},
    {'image': 'assets/reward/kurikulum.jpeg', 'title': 'Kurikulum Terbaik'},
    {
      'image': 'assets/reward/nbnv.jpg',
      'title': 'Peringkat 1 Kualitas Lulusan'
    },
    {'image': 'assets/reward/nk.jpeg', 'title': 'PTS Peringkat 1 di Sumbagsel'},
    {'image': 'assets/reward/akrditas.png', 'title': 'Akreditasi Baik Sekali'},
  ];

  int _current = 0;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: sliderItems.map((item) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item['image']!,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100);
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title']!,
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            /// Dot Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderItems.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _current == entry.key ? 20.0 : 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _current == entry.key
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),

            /// Judul Section
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Penghargaan!',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Grid View Penghargaan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gridItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.asset(
                            item['image']!,
                            width: double.infinity,
                            height: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 80);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item['title']!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
