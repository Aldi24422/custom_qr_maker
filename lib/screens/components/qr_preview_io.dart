// Platform-specific file loading for mobile/desktop (dart:io)
import 'dart:io';
import 'package:flutter/services.dart';

/// Load file bytes from path - mobile/desktop implementation
Future<Uint8List> loadFileBytes(String path) async {
  if (path.startsWith('/') || path.contains(':\\') || path.contains(':/')) {
    // It's a file path (from ImagePicker)
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    } else {
      throw Exception('File not found: $path');
    }
  } else {
    // It's an asset path
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
}
