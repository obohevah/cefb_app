import 'package:flutter/material.dart';

/// Authentic vector brand icons for Church Footer matching the website
class SocialIcons {
  SocialIcons._();

  /// Authentic Facebook 'f' logo
  static Widget facebook({double size = 18, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FacebookPainter(color: color),
    );
  }

  /// Authentic Instagram camera glyph logo
  static Widget instagram({double size = 18, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InstagramPainter(color: color),
    );
  }

  /// Authentic YouTube play badge logo
  static Widget youtube({double size = 18, Color color = Colors.white}) {
    return CustomPaint(
      size: Size(size * 1.3, size),
      painter: _YouTubePainter(color: color),
    );
  }

  /// Authentic KingsChat logo from website assets (1b.png)
  static Widget kingschat({double size = 20, Color? color}) {
    return Image.asset(
      'assets/images/1b.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      errorBuilder: (_, __, ___) => Icon(Icons.chat_bubble, size: size, color: color ?? Colors.white),
    );
  }
}

class _FacebookPainter extends CustomPainter {
  final Color color;
  _FacebookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.65, h)
      ..lineTo(w * 0.42, h)
      ..lineTo(w * 0.42, h * 0.53)
      ..lineTo(w * 0.28, h * 0.53)
      ..lineTo(w * 0.28, h * 0.38)
      ..lineTo(w * 0.42, h * 0.38)
      ..lineTo(w * 0.42, h * 0.26)
      ..cubicTo(w * 0.42, h * 0.12, w * 0.50, 0, w * 0.72, 0)
      ..lineTo(w * 0.86, 0.01)
      ..lineTo(w * 0.86, h * 0.16)
      ..lineTo(w * 0.75, h * 0.16)
      ..cubicTo(w * 0.67, h * 0.16, w * 0.65, h * 0.20, w * 0.65, h * 0.26)
      ..lineTo(w * 0.65, h * 0.38)
      ..lineTo(w * 0.85, h * 0.38)
      ..lineTo(w * 0.82, h * 0.53)
      ..lineTo(w * 0.65, h * 0.53)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FacebookPainter oldDelegate) => oldDelegate.color != color;
}

class _InstagramPainter extends CustomPainter {
  final Color color;
  _InstagramPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final pad = strokePaint.strokeWidth / 2;

    // Outer rounded rect
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(pad, pad, w - pad, h - pad),
      Radius.circular(w * 0.28),
    );
    canvas.drawRRect(outerRect, strokePaint);

    // Inner circle (lens)
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.24, strokePaint);

    // Flash dot
    canvas.drawCircle(Offset(w * 0.74, h * 0.26), w * 0.05, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _InstagramPainter oldDelegate) => oldDelegate.color != color;
}

class _YouTubePainter extends CustomPainter {
  final Color color;
  _YouTubePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer badge outline
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.11
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pad = strokePaint.strokeWidth / 2;
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(pad, pad, w - pad, h - pad),
      Radius.circular(h * 0.32),
    );
    canvas.drawRRect(badgeRect, strokePaint);

    // Center play triangle
    final playPath = Path()
      ..moveTo(w * 0.42, h * 0.30)
      ..lineTo(w * 0.65, h * 0.50)
      ..lineTo(w * 0.42, h * 0.70)
      ..close();

    canvas.drawPath(playPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _YouTubePainter oldDelegate) => oldDelegate.color != color;
}
