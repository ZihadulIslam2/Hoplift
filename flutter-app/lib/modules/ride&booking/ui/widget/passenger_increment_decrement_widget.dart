import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerIncrementDecrementWidget extends StatelessWidget {
  final RxInt count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  const PassengerIncrementDecrementWidget({super.key, required this.count, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return ObxValue(
        (count)=> Row(
          children: [
            Opacity(
              opacity: count.value > 1 ? 1 : 0.5,
              child: IconButton(
                onPressed: count.value <= 1 ? null : () {
                  if (count.value > 1) {
                    onDecrement();
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ),
            Container(
              height: 35,
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                '${count.value}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Opacity(
              opacity: count.value < 4 ? 1 : 0.5,
              child: IconButton(
                onPressed: count.value >= 4 ? null : () {
                  onIncrement();
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ),
          ],
        ),
        count
      );
              
  }
}