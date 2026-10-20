import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookedRideCardSkeleton extends StatelessWidget {
  BookedRideCardSkeleton({super.key});
  // Initilizing variables with minimum and max values
  double containerWidth = 80;
  double spacing = 8;
  double avatarSize = 60;
  int maxUsers = 4;

  calculateSpace(BoxConstraints constraints) {
    containerWidth = max(0, min(containerWidth, (constraints.maxWidth - ((maxUsers - 1) * spacing)) / maxUsers));
    spacing = max(spacing, (constraints.maxWidth - ((containerWidth * (maxUsers)))) / (maxUsers));
    avatarSize = min(avatarSize, containerWidth);
    debugPrint("containerWidth: $containerWidth, spacing: $spacing, avatarSize: $avatarSize");
    debugPrint("=== ${constraints.maxWidth - ((maxUsers - 1) * spacing) - (containerWidth * maxUsers)} ===");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        calculateSpace(constraints);
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  // From / To row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ... List.generate(2, (index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            _buildBox(width: 140, height: 14),
                            _buildBox(width: 120, height: 14),
                          ],
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 20),
                      
                  // Riders placeholder (4 slots)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: spacing,
                    children: List.generate(
                      4,
                      (i) => SizedBox(
                        width: containerWidth,
                        child: Column(
                          children: [
                            CircleAvatar(radius: avatarSize / 2, backgroundColor: Colors.white),
                            const SizedBox(height: 8),
                            _buildBox(width: min(40, avatarSize), height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                      
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  const SizedBox(height: 12),
                      
                  // Action buttons row (Leave / Chat)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildBox(width: 80, height: 20),
                      _buildBox(width: 80, height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildBox({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
