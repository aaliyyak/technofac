import 'package:flutter/material.dart';

import '../themes/themes.dart';
import 'fasilitas.dart';
import 'penghargaan.dart';
import 'sambutan.dart';
import 'sejarah.dart';
import 'visimisi.dart';

class UIGMPage extends StatefulWidget {
  const UIGMPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UIGMPageState createState() => _UIGMPageState();
}

class _UIGMPageState extends State<UIGMPage>
    with SingleTickerProviderStateMixin {
  final List<String> fields = [
    'Sambutan Rektor',
    'Sejarah',
    'Visi & Misi',
    'Fasilitas',
    'Penghargaan',
  ];

  final Map<String, String> fieldTexts = {
    'Sambutan Rektor':
        'Ini adalah teks sambutan rektor yang akan ditampilkan sebagai pop-up.',
    'Sejarah': 'Ini adalah teks sejarah yang akan ditampilkan sebagai pop-up.',
    'Visi & Misi':
        'Ini adalah teks visi dan misi yang akan ditampilkan sebagai pop-up.',
    'Fasilitas':
        'Ini adalah teks fasilitas yang akan ditampilkan sebagai pop-up.',
    'Penghargaan':
        'Ini adalah teks Pengharggan yang akan ditampilkan sebagai pop-up.',
  };

  late AnimationController _animationController;
  late Animation<double> _animation;
  Offset position = const Offset(20, 20);
  bool showImage = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToPage(BuildContext context, String field) {
    if (field == 'Sambutan Rektor') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const KataSambutanPage()));
    } else if (field == 'Sejarah') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SejarahPage()));
    } else if (field == 'Visi & Misi') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const VisiMisiPage()));
    } else if (field == 'Fasilitas') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FasilitasKampusPage()));
    } else if (field == 'Penghargaan') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PenghargaanPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: abuColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(80, 250),
                        bottomRight: Radius.elliptical(870, 300),
                      ),
                      child: Image.asset(
                        "assets/uigm5.jpg",
                        width: double.infinity,
                        height: 290,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios,
                            color: Colors.black),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Universitas",
                                style: TextStyle(
                                  color: redColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Indo Global Mandiri",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Motto "Your Success is Our Commitment"',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Akreditasi "Baik Sekali" oleh BAN-PT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fields.map((field) {
                      return GestureDetector(
                        onTap: () {
                          navigateToPage(context, field);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                field,
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey[600]),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          showImage
              ? Positioned(
                  top: position.dy,
                  left: position.dx,
                  child: Draggable(
                    feedback: Stack(
                      children: [
                        Container(
                          width: 140,
                          height: 110,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/vtt.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showImage = false;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    childWhenDragging: const SizedBox(
                      width: 140,
                      height: 110,
                    ),
                    onDragEnd: (details) {
                      setState(() {
                        position = details.offset;
                      });
                    },
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _animation.value),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 140,
                            height: 110,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.transparent,
                                  blurRadius: 1,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/vtt.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showImage = false;
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
