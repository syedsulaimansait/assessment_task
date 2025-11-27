import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    final half = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        if (i < full) return const Icon(Icons.star, size: 14, color: Colors.amber);
        if (i == full && half) return const Icon(Icons.star_half, size: 14, color: Colors.amber);
        return const Icon(Icons.star_border, size: 14, color: Colors.amber);
      }),
    );
  }
}
