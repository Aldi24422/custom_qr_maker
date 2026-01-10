import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class FileHelperImpl {
  /// Saves bytes to a temporary file
  static Future<String?> saveFile(
    Uint8List bytes,
    String fileName,
    String extension,
  ) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/$fileName.$extension';

      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      debugPrint('FileHelperIO: Error saving file - $e');
      return null;
    }
  }

  /// Shares a file by path
  static Future<bool> shareFile(
    String path,
    Uint8List? bytes,
    String text,
    String subject,
  ) async {
    try {
      await Share.shareXFiles([XFile(path)], text: text, subject: subject);
      return true;
    } catch (e) {
      debugPrint('FileHelperIO: Error sharing file - $e');
      return false;
    }
  }
}
