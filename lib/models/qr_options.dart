import 'package:flutter/material.dart';

/// Enum untuk bentuk dot pattern QR Code
enum QrDotShape { square, circle, rounded, classy }

/// Enum untuk bentuk frame mata QR Code (3 kotak besar di sudut)
enum QrEyeFrameShape { square, circle, rounded }

/// Enum untuk bentuk bola mata QR Code (pusat kotak di sudut)
enum QrEyeBallShape { square, circle, rounded }

/// Enum untuk tingkat error correction QR Code
/// L = 7%, M = 15%, Q = 25%, H = 30% error recovery
enum QrErrorLevel {
  low('L - 7%', 1),
  medium('M - 15%', 0),
  quartile('Q - 25%', 3),
  high('H - 30%', 2);

  final String label;
  final int qrLibValue; // Value used by qr package
  const QrErrorLevel(this.label, this.qrLibValue);
}

/// Sentinel class untuk membedakan null eksplisit dari "tidak diset"
class _Unset {
  const _Unset();
}

const _unset = _Unset();

/// Class immutable untuk menyimpan opsi konfigurasi QR Code
@immutable
class QrOptions {
  final double size;
  final double imageMargin;

  // Shapes
  final QrDotShape dotShape;
  final QrEyeFrameShape eyeFrameShape;
  final QrEyeBallShape eyeBallShape;

  // Colors
  final Color dotColor;
  final Color eyeFrameColor;
  final Color eyeBallColor;
  final Color backgroundColor;

  // Logo/Image
  final String? imagePath;

  // Error Correction Level
  final QrErrorLevel errorLevel;

  // Brand removal
  final bool removeBrand;

  // Advanced
  final bool enableAntialiasing;

  const QrOptions({
    this.size = 1000.0,
    this.imageMargin = 10.0,
    this.dotShape = QrDotShape.square,
    this.eyeFrameShape = QrEyeFrameShape.square,
    this.eyeBallShape = QrEyeBallShape.square,
    this.dotColor = const Color(0xFF4A148C), // Deep Purple 900
    this.eyeFrameColor = const Color(0xFFB71C1C), // Red 900
    this.eyeBallColor = const Color(0xFF4A148C), // Deep Purple 900
    this.backgroundColor = const Color(0xFFFFFFFF), // White
    this.imagePath,
    this.errorLevel = QrErrorLevel.high, // Default high for logo support
    this.removeBrand = false,
    this.enableAntialiasing = true,
  });

  /// Creates a copy of this QrOptions with the given fields replaced
  /// Uses sentinel pattern to properly handle null values for imagePath
  QrOptions copyWith({
    double? size,
    double? imageMargin,
    QrDotShape? dotShape,
    QrEyeFrameShape? eyeFrameShape,
    QrEyeBallShape? eyeBallShape,
    Color? dotColor,
    Color? eyeFrameColor,
    Color? eyeBallColor,
    Color? backgroundColor,
    Object? imagePath = _unset,
    QrErrorLevel? errorLevel,
    bool? removeBrand,
    bool? enableAntialiasing,
  }) {
    return QrOptions(
      size: size ?? this.size,
      imageMargin: imageMargin ?? this.imageMargin,
      dotShape: dotShape ?? this.dotShape,
      eyeFrameShape: eyeFrameShape ?? this.eyeFrameShape,
      eyeBallShape: eyeBallShape ?? this.eyeBallShape,
      dotColor: dotColor ?? this.dotColor,
      eyeFrameColor: eyeFrameColor ?? this.eyeFrameColor,
      eyeBallColor: eyeBallColor ?? this.eyeBallColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imagePath: imagePath == _unset ? this.imagePath : imagePath as String?,
      errorLevel: errorLevel ?? this.errorLevel,
      removeBrand: removeBrand ?? this.removeBrand,
      enableAntialiasing: enableAntialiasing ?? this.enableAntialiasing,
    );
  }

  /// Serializes QrOptions to JSON-compatible Map
  /// Colors are stored as integer ARGB values
  /// Enums are stored as their index
  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'imageMargin': imageMargin,
      'dotShape': dotShape.index,
      'eyeFrameShape': eyeFrameShape.index,
      'eyeBallShape': eyeBallShape.index,
      'dotColor': dotColor.toARGB32(),
      'eyeFrameColor': eyeFrameColor.toARGB32(),
      'eyeBallColor': eyeBallColor.toARGB32(),
      'backgroundColor': backgroundColor.toARGB32(),
      'imagePath': imagePath,
      'errorLevel': errorLevel.index,
      'removeBrand': removeBrand,
      'enableAntialiasing': enableAntialiasing,
    };
  }

  /// Creates QrOptions from JSON Map
  /// Handles missing or invalid values with defaults
  factory QrOptions.fromJson(Map<String, dynamic> json) {
    return QrOptions(
      size: (json['size'] as num?)?.toDouble() ?? 1000.0,
      imageMargin: (json['imageMargin'] as num?)?.toDouble() ?? 10.0,
      dotShape: _parseDotShape(json['dotShape']),
      eyeFrameShape: _parseEyeFrameShape(json['eyeFrameShape']),
      eyeBallShape: _parseEyeBallShape(json['eyeBallShape']),
      dotColor: _parseColor(json['dotColor'], const Color(0xFF4A148C)),
      eyeFrameColor: _parseColor(
        json['eyeFrameColor'],
        const Color(0xFFB71C1C),
      ),
      eyeBallColor: _parseColor(json['eyeBallColor'], const Color(0xFF4A148C)),
      backgroundColor: _parseColor(
        json['backgroundColor'],
        const Color(0xFFFFFFFF),
      ),
      imagePath: json['imagePath'] as String?,
      errorLevel: _parseErrorLevel(json['errorLevel']),
      removeBrand: json['removeBrand'] as bool? ?? false,
      enableAntialiasing: json['enableAntialiasing'] as bool? ?? true,
    );
  }

  /// Helper to parse QrDotShape from index with fallback
  static QrDotShape _parseDotShape(dynamic value) {
    if (value is int && value >= 0 && value < QrDotShape.values.length) {
      return QrDotShape.values[value];
    }
    return QrDotShape.square;
  }

  /// Helper to parse QrEyeFrameShape from index with fallback
  static QrEyeFrameShape _parseEyeFrameShape(dynamic value) {
    if (value is int && value >= 0 && value < QrEyeFrameShape.values.length) {
      return QrEyeFrameShape.values[value];
    }
    return QrEyeFrameShape.square;
  }

  /// Helper to parse QrEyeBallShape from index with fallback
  static QrEyeBallShape _parseEyeBallShape(dynamic value) {
    if (value is int && value >= 0 && value < QrEyeBallShape.values.length) {
      return QrEyeBallShape.values[value];
    }
    return QrEyeBallShape.square;
  }

  /// Helper to parse Color from ARGB int with fallback
  static Color _parseColor(dynamic value, Color fallback) {
    if (value is int) {
      return Color.fromARGB(
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      );
    }
    return fallback;
  }

  /// Helper to parse QrErrorLevel from index with fallback
  static QrErrorLevel _parseErrorLevel(dynamic value) {
    if (value is int && value >= 0 && value < QrErrorLevel.values.length) {
      return QrErrorLevel.values[value];
    }
    return QrErrorLevel.high;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QrOptions &&
        other.size == size &&
        other.imageMargin == imageMargin &&
        other.dotShape == dotShape &&
        other.eyeFrameShape == eyeFrameShape &&
        other.eyeBallShape == eyeBallShape &&
        other.dotColor == dotColor &&
        other.eyeFrameColor == eyeFrameColor &&
        other.eyeBallColor == eyeBallColor &&
        other.backgroundColor == backgroundColor &&
        other.imagePath == imagePath &&
        other.errorLevel == errorLevel &&
        other.removeBrand == removeBrand;
  }

  @override
  int get hashCode {
    return Object.hash(
      size,
      imageMargin,
      dotShape,
      eyeFrameShape,
      eyeBallShape,
      dotColor,
      eyeFrameColor,
      eyeBallColor,
      backgroundColor,
      imagePath,
      errorLevel,
      removeBrand,
    );
  }

  @override
  String toString() {
    return 'QrOptions(size: $size, dotShape: $dotShape, dotColor: $dotColor)';
  }
}
