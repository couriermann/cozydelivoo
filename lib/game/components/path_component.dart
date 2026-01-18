import 'dart:ui';
import 'package:flame/components.dart';
import '../../ui/theme.dart';

class PathComponent extends PositionComponent {
  final List<Vector2> points = [];
  final Paint _paint = Paint()
    ..color = CozyTheme.inkBlue
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  PathComponent() : super(priority: 0);

  void clear() {
    points.clear();
  }

  void addPoint(Vector2 point) {
    points.add(point);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (points.length < 2) return;

    final path = Path();
    path.moveTo(points.first.x, points.first.y);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }

    // Draw dashed line
    final Path dashedPath = Path();
    double dashWidth = 10.0;
    double dashSpace = 5.0;
    double distance = 0.0;
    
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, _paint);
  }
}

