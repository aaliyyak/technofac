import 'package:flutter/material.dart';

class VisiMisiPage extends StatelessWidget {
  const VisiMisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'VISI DAN MISI',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // VISI
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(180, 250),
                  bottomRight: Radius.elliptical(850, 280),
                ),
              ),
              elevation: 4,
              color: Color.fromARGB(255, 236, 207, 207),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Visi',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Universitas IGM Menghasilkan Sumber Daya Profesional dan Berintegritas untuk Mengisi dan/atau Menciptakan Peluang Kerja',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // MISI
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(180, 220),
                  topRight: Radius.elliptical(850, 290),
                ),
              ),
              elevation: 4,
              color: Color.fromARGB(255, 234, 208, 208),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Misi',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Menciptakan atmosfir pendidikan yang dapat direkognisi secara nasional dan internasional.',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '2. Mewujudkan kemitraan strategis dengan mitra dalam negeri dan luar negeri.',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '3. Menciptakan relevansi penelitian dan pengabdian kepada masyarakat.',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '4. Mengembangkan link and match antar dunia pendidikan, dunia kerja dan bisnis.',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '5. Membangun karakter yang religius, profesional dan berintegritas.',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
