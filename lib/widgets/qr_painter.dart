import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import '../models/qr_options.dart';

/// CustomPainter untuk menggambar QR Code dengan custom shapes
/// Mendukung berbagai bentuk dot, eye frame, dan eye ball
class QrPainter extends CustomPainter {
  final QrImage qrImage;
  final QrOptions options;
  final ui.Image? logoImage;

  // Finder pattern positions (top-left, top-right, bottom-left)
  // Size is 7x7 modules
  static const int finderPatternSize = 7;

  QrPainter({required this.qrImage, required this.options, this.logoImage});

  @override
  void paint(Canvas canvas, Size size) {
    final moduleCount = qrImage.moduleCount;
    final moduleSize = size.width / moduleCount;

    // Calculate logo exclusion zone
    final logoZone = _calculateLogoZone(size, moduleCount, moduleSize);

    // Paint background using options.backgroundColor
    final bgPaint = Paint()
      ..color = options.backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw data modules (non-finder pattern areas)
    _drawDataModules(canvas, moduleCount, moduleSize, logoZone);

    // Draw finder patterns (eyes) at three corners
    _drawFinderPattern(canvas, 0, 0, moduleSize); // Top-left
    _drawFinderPattern(
      canvas,
      moduleCount - finderPatternSize,
      0,
      moduleSize,
    ); // Top-right
    _drawFinderPattern(
      canvas,
      0,
      moduleCount - finderPatternSize,
      moduleSize,
    ); // Bottom-left

    // Draw logo if available
    if (logoImage != null) {
      _drawLogo(canvas, size, logoZone);
    }
  }

  /// Calculate the exclusion zone for logo in the center
  Rect _calculateLogoZone(Size size, int moduleCount, double moduleSize) {
    if (logoImage == null) return Rect.zero;

    // Logo takes up about 20-25% of QR code
    final logoSize = size.width * 0.22;
    final margin = options.imageMargin;
    final totalSize = logoSize + (margin * 2);

    final center = size.width / 2;
    return Rect.fromCenter(
      center: Offset(center, center),
      width: totalSize,
      height: totalSize,
    );
  }

  /// Check if a module is within the finder pattern areas
  bool _isFinderPatternArea(int x, int y, int moduleCount) {
    // Top-left finder pattern
    if (x < finderPatternSize && y < finderPatternSize) return true;
    // Top-right finder pattern
    if (x >= moduleCount - finderPatternSize && y < finderPatternSize) {
      return true;
    }
    // Bottom-left finder pattern
    if (x < finderPatternSize && y >= moduleCount - finderPatternSize) {
      return true;
    }
    return false;
  }

  /// Check if a module is within the logo exclusion zone
  bool _isInLogoZone(int x, int y, double moduleSize, Rect logoZone) {
    if (logoZone == Rect.zero) return false;

    final moduleCenter = Offset((x + 0.5) * moduleSize, (y + 0.5) * moduleSize);
    return logoZone.contains(moduleCenter);
  }

  /// Draw all data modules (excluding finder patterns and logo zone)
  void _drawDataModules(
    Canvas canvas,
    int moduleCount,
    double moduleSize,
    Rect logoZone,
  ) {
    final dotPaint = Paint()
      ..color = options.dotColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = options.enableAntialiasing;

    for (int y = 0; y < moduleCount; y++) {
      for (int x = 0; x < moduleCount; x++) {
        // Skip finder pattern areas
        if (_isFinderPatternArea(x, y, moduleCount)) continue;

        // Skip logo zone
        if (_isInLogoZone(x, y, moduleSize, logoZone)) continue;

        // Only draw if module is dark
        if (qrImage.isDark(y, x)) {
          _drawDot(
            canvas,
            x * moduleSize,
            y * moduleSize,
            moduleSize,
            dotPaint,
            x,
            y,
            moduleCount,
          );
        }
      }
    }
  }

  /// Draw a single dot based on the selected shape
  void _drawDot(
    Canvas canvas,
    double left,
    double top,
    double size,
    Paint paint,
    int x,
    int y,
    int moduleCount,
  ) {
    // Add small padding for visual separation
    final padding = size * 0.08;
    final adjustedSize = size - (padding * 2);
    final adjustedLeft = left + padding;
    final adjustedTop = top + padding;

    switch (options.dotShape) {
      case QrDotShape.square:
        canvas.drawRect(
          Rect.fromLTWH(adjustedLeft, adjustedTop, adjustedSize, adjustedSize),
          paint,
        );
        break;

      case QrDotShape.circle:
        final center = Offset(
          adjustedLeft + adjustedSize / 2,
          adjustedTop + adjustedSize / 2,
        );
        canvas.drawCircle(center, adjustedSize / 2, paint);
        break;

      case QrDotShape.rounded:
        final radius = adjustedSize * 0.3;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              adjustedLeft,
              adjustedTop,
              adjustedSize,
              adjustedSize,
            ),
            Radius.circular(radius),
          ),
          paint,
        );
        break;

      case QrDotShape.classy:
        // Classy: rounded corners based on neighbors
        _drawClassyDot(
          canvas,
          adjustedLeft,
          adjustedTop,
          adjustedSize,
          paint,
          x,
          y,
          moduleCount,
        );
        break;
    }
  }

  /// Draw classy dot with neighbor-aware rounded corners
  void _drawClassyDot(
    Canvas canvas,
    double left,
    double top,
    double size,
    Paint paint,
    int x,
    int y,
    int moduleCount,
  ) {
    // Check neighbors (use qrImage.isDark for neighbor checking)
    final hasTop = y > 0 && qrImage.isDark(y - 1, x);
    final hasBottom = y < moduleCount - 1 && qrImage.isDark(y + 1, x);
    final hasLeft = x > 0 && qrImage.isDark(y, x - 1);
    final hasRight = x < moduleCount - 1 && qrImage.isDark(y, x + 1);

    final radius = size * 0.5;

    // Determine which corners to round based on neighbors
    final topLeftRadius = (!hasTop && !hasLeft) ? radius : 0.0;
    final topRightRadius = (!hasTop && !hasRight) ? radius : 0.0;
    final bottomLeftRadius = (!hasBottom && !hasLeft) ? radius : 0.0;
    final bottomRightRadius = (!hasBottom && !hasRight) ? radius : 0.0;

    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(left, top, size, size),
      topLeft: Radius.circular(topLeftRadius),
      topRight: Radius.circular(topRightRadius),
      bottomLeft: Radius.circular(bottomLeftRadius),
      bottomRight: Radius.circular(bottomRightRadius),
    );

    canvas.drawRRect(rrect, paint);
  }

  /// Draw finder pattern (eye) at specified position
  void _drawFinderPattern(
    Canvas canvas,
    int startX,
    int startY,
    double moduleSize,
  ) {
    final left = startX * moduleSize;
    final top = startY * moduleSize;
    final patternSize = finderPatternSize * moduleSize;

    // Draw outer frame (7x7)
    _drawEyeFrame(canvas, left, top, patternSize);

    // Draw inner ball (3x3, offset by 2 modules)
    final innerOffset = 2 * moduleSize;
    final innerSize = 3 * moduleSize;
    _drawEyeBall(canvas, left + innerOffset, top + innerOffset, innerSize);
  }

  /// Draw eye frame (outer ring of finder pattern)
  void _drawEyeFrame(Canvas canvas, double left, double top, double size) {
    final framePaint = Paint()
      ..color = options.eyeFrameColor
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          size /
          7 // 1 module width
      ..isAntiAlias = true;

    // Inset by half stroke width to draw centered
    final inset = framePaint.strokeWidth / 2;
    final frameRect = Rect.fromLTWH(
      left + inset,
      top + inset,
      size - (inset * 2),
      size - (inset * 2),
    );

    switch (options.eyeFrameShape) {
      case QrEyeFrameShape.square:
        canvas.drawRect(frameRect, framePaint);
        break;

      case QrEyeFrameShape.circle:
        canvas.drawOval(frameRect, framePaint);
        break;

      case QrEyeFrameShape.rounded:
        final radius = size * 0.2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(frameRect, Radius.circular(radius)),
          framePaint,
        );
        break;
    }
  }

  /// Draw eye ball (inner filled part of finder pattern)
  void _drawEyeBall(Canvas canvas, double left, double top, double size) {
    final ballPaint = Paint()
      ..color = options.eyeBallColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final ballRect = Rect.fromLTWH(left, top, size, size);

    switch (options.eyeBallShape) {
      case QrEyeBallShape.square:
        canvas.drawRect(ballRect, ballPaint);
        break;

      case QrEyeBallShape.circle:
        canvas.drawOval(ballRect, ballPaint);
        break;

      case QrEyeBallShape.rounded:
        final radius = size * 0.3;
        canvas.drawRRect(
          RRect.fromRectAndRadius(ballRect, Radius.circular(radius)),
          ballPaint,
        );
        break;
    }
  }

  /// Draw logo image in the center
  void _drawLogo(Canvas canvas, Size size, Rect logoZone) {
    if (logoImage == null) return;

    // Draw white background behind logo
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final margin = options.imageMargin;
    final bgRect = Rect.fromCenter(
      center: logoZone.center,
      width: logoZone.width,
      height: logoZone.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, Radius.circular(margin)),
      bgPaint,
    );

    // Calculate logo destination rect
    final logoSize = logoZone.width - (margin * 2);
    final logoRect = Rect.fromCenter(
      center: logoZone.center,
      width: logoSize,
      height: logoSize,
    );

    // Source rect (entire image)
    final srcRect = Rect.fromLTWH(
      0,
      0,
      logoImage!.width.toDouble(),
      logoImage!.height.toDouble(),
    );

    canvas.drawImageRect(logoImage!, srcRect, logoRect, Paint());
  }

  @override
  bool shouldRepaint(covariant QrPainter oldDelegate) {
    return oldDelegate.qrImage != qrImage ||
        oldDelegate.options != options ||
        oldDelegate.logoImage != logoImage;
  }
}
