import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class FileHelperImpl {
  /// Saves bytes by triggering a browser download
  static Future<String?> saveFile(
    Uint8List bytes,
    String fileName,
    String extension,
  ) async {
    try {
      // Create a blob from the bytes
      final blob = web.Blob([bytes.toJS].toJS);
      // Create an object URL for the blob
      final url = web.URL.createObjectURL(blob);

      // Create an anchor element and trigger download
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = '$fileName.$extension';
      anchor.click();

      // Cleanup
      web.URL.revokeObjectURL(url);

      return 'Downloads folder';
    } catch (e) {
      debugPrint('FileHelperWeb: Error parsing blob - $e');
      return null;
    }
  }

  /// Shares a file using Web Share API if available, or fallbacks
  static Future<bool> shareFile(
    String path,
    Uint8List? bytes,
    String text,
    String subject,
  ) async {
    try {
      // Try using share_plus with bytes if available
      if (bytes != null) {
        // Create an XFile from bytes
        final xFile = XFile.fromData(
          bytes,
          name: 'qr_code.png',
          mimeType: 'image/png',
        );

        // Share.shareXFiles on web might not support files on all browsers/contexts
        // But we try anyway.
        await Share.shareXFiles([xFile], text: text, subject: subject);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('FileHelperWeb: Error sharing file - $e');
      // If share fails (e.g. not supported), return false so UI can handle (maybe show toast)
      return false;
    }
  }
}
