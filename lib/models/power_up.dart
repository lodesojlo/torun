import 'dart:math' as math;
import 'package:flutter/material.dart';

class PowerUp {
  static const Map<String, Map<String, dynamic>> types = {
    'speed': {
      'name': '⚡ سرعة',
      'color': '#ffff00',
      'duration': 300,
      'icon': '⚡',
    },
    'shield': {
      'name': '🛡️ درع',
      'color': '#00ffff',
      'duration': 400,
      'icon': '🛡️',
    },
    'coin_magnet': {
      'name': '💰 مغناطيس',
      'color': '#ffcc00',
      'duration': 500,
      'icon': '💰',
    },
    'double_coins': {
      'name': '✨ عملات مضاعفة',
      'color': '#ff00ff',
      'duration': 400,
      'icon': '✨',
    },
    'slow_motion': {
      'name': '🐢 بطء الوقت',
      'color': '#88ff88',
      'duration': 300,
      'icon': '🐢',
    },
  };

  double x;
  double y;
  String type;
  Map<String, dynamic> data;
  double size = 35;
  double floatPhase = 0;
  bool collected = false;

  PowerUp({required this.x, required this.y, required this.type})
      : data = types[type] ?? types['speed']!;

  void update(double gameSpeed) {
    x -= gameSpeed;
    floatPhase += 0.15;
  }

  bool isOffscreen() => x + size < 0;

  Rect getRect() => Rect.fromLTWH(x, y, size, size);

  static Color _parseHexColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  void draw(Canvas canvas) {
    final floatOffset = math.sin(floatPhase) * 5;
    final centerX = x + size / 2;
    final centerY = y + size / 2 + floatOffset;
    final color = _parseHexColor(data['color'] as String);

    // ✅ Glow
    for (int i = 4; i >= 1; i--) {
      final glowPaint = Paint()..color = color.withValues(alpha: 50 / 255);
      canvas.drawCircle(
        Offset(centerX, centerY),
        size / 2 + i * 3,
        glowPaint,
      );
    }

    // ✅ Main circle
    final circlePaint = Paint()..color = color;
    canvas.drawCircle(Offset(centerX, centerY), size / 2, circlePaint);

    // ✅ Border
    final borderPaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(centerX, centerY), size / 2, borderPaint);

    // ✅ Icon
    final textPainter = TextPainter(
      text: TextSpan(
        text: data['icon'] as String,
        style: TextStyle(
          fontSize: size * 0.55,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2,
      ),
    );
  }
}