import 'package:assessment_task/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
      //final Color starColor = Color(0xFF0E7490);

    final full = rating.floor();
    final half = (rating - full) >= 0.5;
    return Row(
      children: List.generate(5, (i) {
        if (i < full) {
          return  Icon(Icons.star, size: 14, color: Color(AppColor.ratingStarColor));
        }
        if (i == full && half) {
          return Icon(
            Icons.star_half,
            size: 14,
            color:Color(AppColor.ratingStarColor)
          );
        }
        return Icon(
          Icons.star_border,
          size: 14,
          color: Color(AppColor.ratingStarColor)
        );
      }),
    );
  }
}
