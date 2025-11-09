import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonView extends StatelessWidget {
  const SkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            width: 200,
            height: 32,
            color: Colors.white,
          ),
          const SizedBox(height: 10),

          Container(
            width: 150,
            height: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 10),

          Container(
            width: 250,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
