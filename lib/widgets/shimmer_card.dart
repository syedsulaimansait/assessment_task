import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Container(
              height: 12,
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.grey,
            ),
            Container(
              height: 12,
              margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
