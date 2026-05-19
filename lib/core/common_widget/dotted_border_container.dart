import 'package:flutter/material.dart';

class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dotSpacing;
  final double dotLength;
  final EdgeInsets padding;

  const DottedBorderContainer({super.key, required this.child, this.radius = 12, this.color = const Color(0xffE4E8E9), this.strokeWidth = 1, this.dotSpacing = 6, this.dotLength = 10, this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    // CustomPaint will size to its child, so wrap child with padding as required.
    return CustomPaint(
      painter: _DottedBorderPainter(radius: radius, color: color, strokeWidth: strokeWidth, dotSpacing: dotSpacing, dotLength: dotLength),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dotSpacing;
  final double dotLength;

  _DottedBorderPainter({required this.radius, required this.color, required this.strokeWidth, required this.dotSpacing, required this.dotLength});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // make dots rounded

    // inset the rect by half stroke so the stroke isn't clipped
    final Rect rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final path = Path()..addRRect(rrect);

    // iterate through path metrics and draw short segments (dots)
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double end = (distance + dotLength).clamp(0.0, metric.length);
        final Path extract = metric.extractPath(distance, end);
        canvas.drawPath(extract, paint);
        distance += dotLength + dotSpacing;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter old) {
    return old.radius != radius || old.color != color || old.strokeWidth != strokeWidth || old.dotSpacing != dotSpacing || old.dotLength != dotLength;
  }
}