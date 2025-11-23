import 'package:flutter/material.dart';

import '../themes/themes.dart';

class KataSambutanPage extends StatelessWidget {
  const KataSambutanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Teks sambutan terpisah agar bisa diatur alignment-nya masing-masing
    String opening =
        'Assalamualaikum Warahmatullahi Wabarakatuh.\nPeace be upon all of us.';
    String body = '''
The long journey that has been gone through since its establishment in 1999 which started with Sekolah Tinggi, has formed IGM into a tough Institution facing difficulties with increasingly tough competition. The growing number of alumni who are successful in their careers and in the business world further strengthens the existence of IGM in education.

The increasingly tough competition between Domestic Universities and the entry of foreign universities is a challenge for the Universitas IGM to keep on racing ahead, be the best in South Sumatra Region, and get into the top 100 best universities in Indonesia in the next 5 years from around 4000 State and Private universities. In the next two decades, IGM University is targeted to be among the top 500 Universities in the World.

The way is wide open, man's job is to try, but everything goes back to the Provisions of the Almighty. We believe with the support of all Parties, including alumni who have succeeded in achieving their goals, by holding tight to the vision and mission of the foundations, challenges and obstacles will be well overcome and the opportunities will be well achieved by using the strengths and overcoming the existed weaknesses.

Thank you.

GLORY FOR INDO GLOBAL MANDIRI GLORY FOR MY COUNTRY
''';
    String closing = 'Wassalamu\'alaikum Warahmatullahi Wabarakatuh.';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Positioned(
            top: 10,
            right: 0,
            child: Image.asset(
              'assets/6.png',
              width: 90,
              height: 120,
            ),
          ),
          Positioned(
            bottom: 300,
            left: 0,
            child: Image.asset(
              'assets/7.png',
              width: 60,
              height: 118,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Foto Rektor dengan shadow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    //borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/rektor.jpg',
                      height: 250,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Kutipan
                const Text(
                  '"Bersama IGM Untuk Indonesia Unggul"',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Satu box sambutan
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assalamualaikum (tanpa justify)
                      Text(
                        opening,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),

                      // Isi utama (justify)
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 12),

                      // Wassalamu'alaikum (tanpa justify)
                      Text(
                        closing,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
