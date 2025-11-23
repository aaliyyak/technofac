import 'package:flutter/material.dart';
import '../models/spot_model.dart';

class SpotCard extends StatelessWidget {
  final Spot spot;

  const SpotCard({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              spot.imageAsset,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Detail Teks
          Expanded(
            child: ListTile(
              title: Text(
                spot.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        spot.rating.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                Icons.place,
                color: spot.isFavorite ? Colors.redAccent : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
