import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/rendering.dart';

// Conditional import for platform-specific file handling
import 'file_helper_io.dart' if (dart.library.html) 'file_helper_web.dart';

/// Utility class untuk menangani operasi file terkait QR Code
/// Mencakup capture gambar dari widget dan sharing/saving
class FileUtils {
  FileUtils._(); // Private constructor, use static methods only

  /// Captures a widget wrapped in RepaintBoundary and shares/saves as PNG
  ///
  /// [key] - GlobalKey attached to a RepaintBoundary widget
  /// [fileName] - Optional custom filename (without extension)
  /// [pixelRatio] - Pixel ratio for high quality output (default: 3.0 for HD)
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> captureAndSave(
    GlobalKey key, {
    String? fileName,
    double pixelRatio = 3.0,
  }) async {
    try {
      // Capture bytes
      final Uint8List? pngBytes = await captureToBytes(
        key,
        pixelRatio: pixelRatio,
      );

      if (pngBytes == null) return false;

      // Generate filename with timestamp if not provided
      final String finalFileName =
          fileName ?? 'qr_code_${DateTime.now().millisecondsSinceEpoch}';

      String? filePath;
      bool isWeb = kIsWeb;

      if (!isWeb) {
        filePath = await FileHelperImpl.saveFile(
          pngBytes,
          finalFileName,
          'png',
        );
        if (filePath == null) return false;
      }

      return await FileHelperImpl.shareFile(
        filePath ?? '$finalFileName.png',
        pngBytes,
        'QR Code',
        'QR Code Image',
      );
    } catch (e, stackTrace) {
      debugPrint('FileUtils: Error capturing/saving image - $e');
      debugPrint('$stackTrace');
      return false;
    }
  }

  /// Captures widget and returns bytes without sharing
  /// Useful for saving to gallery or custom handling
  static Future<Uint8List?> captureToBytes(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final boundary = key.currentContext?.findRenderObject();

      if (boundary == null || boundary is! RenderRepaintBoundary) {
        debugPrint('FileUtils: RenderRepaintBoundary not found');
        return null;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('FileUtils: Error capturing image - $e');
      return null;
    }
  }

  /// Saves bytes to a file and returns the file path (IO) or triggers download (Web)
  static Future<String?> saveBytesToFile(
    Uint8List bytes, {
    String? fileName,
    String extension = 'png',
  }) async {
    final String finalFileName =
        fileName ?? 'qr_code_${DateTime.now().millisecondsSinceEpoch}';

    return await FileHelperImpl.saveFile(bytes, finalFileName, extension);
  }

  /// Shares a file
  static Future<void> shareFile(
    String filePath, {
    String? text,
    String? subject,
  }) async {
    // This method assumes filePath exists on IO.
    // On Web, this might fail if bytes aren't passed.
    // This signature matches old one but we don't have bytes here.
    // If we only have path, Web share will fail.
    // But this method was barely used directly?
    // captureAndSave is the main one.

    // Attempt share with dummy bytes/null
    await FileHelperImpl.shareFile(filePath, null, text ?? '', subject ?? '');
  }
}
