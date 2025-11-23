class Spot {
  final String name;
  final String description;
  final double rating;
  final bool isFavorite;
  final String imageAsset;
  Spot({
    required this.name,
    required this.description,
    required this.rating,
    this.isFavorite = false,
    required this.imageAsset,
  });
}
