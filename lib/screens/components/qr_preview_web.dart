// Platform-specific file loading for web (no dart:io)
import 'package:flutter/services.dart';

/// Load file bytes from path - web implementation (stub, not actually used)
/// On web, blob URLs are handled directly via http package in the main file
Future<Uint8List> loadFileBytes(String path) async {
  // On web, we shouldn't reach here for blob URLs (handled in main file)
  // This is only for asset paths
  final ByteData data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}
