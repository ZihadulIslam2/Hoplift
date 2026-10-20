import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InboxChatSkeleton extends StatelessWidget {
  const InboxChatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 161, 156, 156),
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text side
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From -> To line
                  Row(
                    children: [
                      _buildBox(width: 80, height: 16),
                      const SizedBox(width: 8),
                      _buildBox(width: 20, height: 16),
                      const SizedBox(width: 8),
                      _buildBox(width: 80, height: 16),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date + Time
                  Row(
                    children: [
                      _buildBox(width: 60, height: 14),
                      const SizedBox(width: 12),
                      _buildBox(width: 40, height: 14),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Last message
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBox(width: 140, height: 14),
                      _buildBox(width: 40, height: 12),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Profile images stacked (just 3 placeholders)
            SizedBox(
              width: 100,
              height: 50,
              child: Stack(
                children: List.generate(3, (i) {
                  return Positioned(
                    left: i * 24.0,
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
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
