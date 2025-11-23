import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shimmer/shimmer.dart';

import '../data/spots_data.dart';
import '../models/spot_model.dart';
import '../themes/themes.dart';
import '../widgets/spot_card.dart';

class SpotRekomendasiPage extends StatefulWidget {
  const SpotRekomendasiPage({super.key});

  @override
  State<SpotRekomendasiPage> createState() => _SpotRekomendasiPageState();
}

class _SpotRekomendasiPageState extends State<SpotRekomendasiPage>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  double _minRating = 0.0;
  bool _showDropdown = false;
  bool _isLoading = false;
  bool _isListening = false;

  late AnimationController _micController;
  late Animation<double> _micAnimation;

  final Map<String, List<String>> synonyms = {
    'belajar': ['belajar', 'mengerjakan tugas', 'nugas', 'membaca'],
    'diskusi': [
      'diskusi',
      'kerja kelompok',
      'rapat',
      'berkumpul',
      'konsultasi'
    ],
    'makan': ['makan', 'ngemil', 'jajan', 'makan siang'],
    'rapat': ['rapat', 'pertemuan', 'organisasi', 'komunitas'],
    'praktikum': ['praktikum', 'lab', 'praktik', 'percobaan'],
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _runInitialLoading();

    _micController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _micAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _micController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _micController.dispose();
    super.dispose();
  }

  void _runInitialLoading() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _isLoading = true;
      });

      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            setState(() {
              _query = result.recognizedWords;
              _searchController.text = result.recognizedWords;
            });
          }

          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isListening = false;
              _isLoading = false;
            });
          });
        },
        localeId: 'id_ID',
        listenFor: const Duration(seconds: 5),
        // ignore: deprecated_member_use
        cancelOnError: true,
      );
    }
  }

  List<Spot> _filterSpots() {
    final lowerQuery = _query.toLowerCase();
    final expandedQuery = synonyms.entries
        .expand((entry) => entry.value.contains(lowerQuery) ? entry.value : [])
        .toList();

    return spotsList.where((spot) {
      final content = '${spot.name} ${spot.description}'.toLowerCase();
      final matchesQuery = expandedQuery.isEmpty
          ? content.contains(lowerQuery)
          : expandedQuery.any((syn) => content.contains(syn));
      return matchesQuery && spot.rating >= _minRating;
    }).toList();
  }

  void _onSearchPressed() {
    setState(() {
      _isLoading = true;
      _query = _searchController.text;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filterSpots();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rekomendasi Spot Favorit ',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _query = value);
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        border: InputBorder.none,
                        hintText: 'Cari spot berdasarkan kata kunci...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(
                          icon: _isListening
                              ? ScaleTransition(
                                  scale: _micAnimation,
                                  child:
                                      const Icon(Icons.mic, color: Colors.red),
                                )
                              : const Icon(Icons.mic, color: Colors.blue),
                          onPressed: _startListening,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.grey),
                          onPressed: _onSearchPressed,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.grey),
                    onPressed: () {
                      setState(() => _showDropdown = !_showDropdown);
                    },
                  ),
                ),
              ],
            ),
          ),

          if (_showDropdown)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<double>(
                  isExpanded: true,
                  value: _minRating,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  style: const TextStyle(color: Colors.black),
                  dropdownColor: Colors.white,
                  items: [0.0, 4.0, 4.5].map((rating) {
                    return DropdownMenuItem<double>(
                      value: rating,
                      child: Text('⭐ ${rating.toString()} +'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _minRating = value);
                    }
                  },
                ),
              ),
            ),

          const SizedBox(height: 10),

          // Loading or result
          Expanded(
            child: _isLoading
                ? ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )
                : results.isEmpty
                    ? const Center(
                        child: Text('Tidak ada spot ditemukan.',
                            style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          return SpotCard(spot: results[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
