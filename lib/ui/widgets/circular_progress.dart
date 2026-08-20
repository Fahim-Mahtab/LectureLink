import 'dart:math';
import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final int percentage;
  final double size;
  final Color progressColor;
  final Color trackColor;

  const CustomCircularProgress({
    super.key,
    required this.percentage,
    this.size = 80.0,
    this.progressColor = const Color(0xFF2563EB),
    this.trackColor = const Color(0xFFEFF6FF),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularPainter(
              percentage: percentage,
              progressColor: progressColor,
              trackColor: trackColor,
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: progressColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularPainter extends CustomPainter {
  final int percentage;
  final Color progressColor;
  final Color trackColor;

  _CircularPainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.1;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
