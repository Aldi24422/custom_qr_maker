import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      // Get the RenderRepaintBoundary from the key
      final boundary = key.currentContext?.findRenderObject();

      if (boundary == null || boundary is! RenderRepaintBoundary) {
        debugPrint('FileUtils: RenderRepaintBoundary not found');
        return false;
      }

      // Capture the image
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      // Convert to PNG bytes
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        debugPrint('FileUtils: Failed to convert image to bytes');
        return false;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();

      // Generate filename with timestamp if not provided
      final String finalFileName =
          fileName ?? 'qr_code_${DateTime.now().millisecondsSinceEpoch}';

      // Create file path
      final String filePath = '${tempDir.path}/$finalFileName.png';

      // Write file
      final File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      debugPrint('FileUtils: Image saved to $filePath');

      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'QR Code',
        subject: 'QR Code Image',
      );

      return true;
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

  /// Saves bytes to a file and returns the file path
  static Future<String?> saveBytesToFile(
    Uint8List bytes, {
    String? fileName,
    String extension = 'png',
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String finalFileName =
          fileName ?? 'qr_code_${DateTime.now().millisecondsSinceEpoch}';

      final String filePath = '${tempDir.path}/$finalFileName.$extension';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      debugPrint('FileUtils: Error saving bytes to file - $e');
      return null;
    }
  }

  /// Shares a file by path
  static Future<void> shareFile(
    String filePath, {
    String? text,
    String? subject,
  }) async {
    try {
      await Share.shareXFiles([XFile(filePath)], text: text, subject: subject);
    } catch (e) {
      debugPrint('FileUtils: Error sharing file - $e');
    }
  }
}
