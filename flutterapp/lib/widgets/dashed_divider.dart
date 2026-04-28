import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedDivider({
    this.height = 1.0,
    this.color = Colors.black,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedDividerPainter(
        color: color,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: Container(
        height: height,
      ),
    );
  }
}

class DashedDividerPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedDividerPainter({
    this.color = Colors.black,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0.0),
        Offset(startX + dashWidth, 0.0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedDividerPainter oldPainter) => false;
}
