import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';

class CarDivider extends StatelessWidget {
  const CarDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDot(isFilled: true),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                painter: DottedLinePainter(),
                child: SizedBox(height: 1),
              );
            },
          ),
        ),
        Gap.w8,

        // Icon(Icons.airline_seat_flat, size: 24, color: Colors.black),
        Image.asset(
          'assets/images/car.png',
          width: 24,
          height: 24,
          color: Colors.black,
        ),
        Gap.w8,
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                painter: DottedLinePainter(),
                child: const SizedBox(height: 1),
              );
            },
          ),
        ),
        _buildDot(isFilled: false),
      ],
    );
  }

  Widget _buildDot({required bool isFilled}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isFilled ? Colors.black : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    const dashWidth = 4;
    const dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
