import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';
import '../../providers/qr_provider.dart';
import '../../widgets/qr_painter.dart';
import '../../utils/file_utils.dart';

import 'qr_preview_io.dart'
    if (dart.library.html) 'qr_preview_web.dart'
    as platform;

class QrPreview extends StatefulWidget {
  const QrPreview({super.key});

  @override
  State<QrPreview> createState() => _QrPreviewState();
}

class _QrPreviewState extends State<QrPreview> {
  ui.Image? _logoImage;
  bool _isExporting = false;
  String? _currentLogoPath;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void dispose() {
    _logoImage?.dispose();
    super.dispose();
  }

  Future<void> _loadLogoImage(String? imagePath) async {
    if (imagePath == _currentLogoPath) return;
    _currentLogoPath = imagePath;

    if (imagePath == null || imagePath.isEmpty) {
      setState(() {
        _logoImage?.dispose();
        _logoImage = null;
      });
      return;
    }

    try {
      Uint8List imageBytes;

      if (kIsWeb) {
        if (imagePath.startsWith('blob:') || imagePath.startsWith('http')) {
          final response = await http.get(Uri.parse(imagePath));
          if (response.statusCode == 200) {
            imageBytes = response.bodyBytes;
          } else {
            throw Exception('Failed to load image');
          }
        } else {
          final ByteData data = await rootBundle.load(imagePath);
          imageBytes = data.buffer.asUint8List();
        }
      } else {
        imageBytes = await platform.loadFileBytes(imagePath);
      }

      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _logoImage?.dispose();
          _logoImage = frame.image;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _logoImage = null);
      }
    }
  }

  QrImage? _generateQrImage(String data, int errorLevel) {
    if (data.isEmpty) return null;
    try {
      final qrCode = QrCode.fromData(data: data, errorCorrectLevel: errorLevel);
      return QrImage(qrCode);
    } catch (e) {
      return null;
    }
  }

  Future<void> _handleShare() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      // captureAndSave internally calls Share.shareXFiles
      final success = await FileUtils.captureAndSave(_qrKey);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to share QR code')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Share failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _handleDownload() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final bytes = await FileUtils.captureToBytes(_qrKey);
      if (bytes != null) {
        final path = await FileUtils.saveBytesToFile(bytes);
        if (mounted) {
          if (path != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Saved to $path')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to save file')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<QrProvider>(
      builder: (context, provider, child) {
        if (provider.options.imagePath != _currentLogoPath) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadLogoImage(provider.options.imagePath);
          });
        }

        final content = provider.data.encodedContent;
        final qrImage = _generateQrImage(
          content,
          provider.options.errorLevel.qrLibValue,
        );
        final hasContent = content.isNotEmpty && qrImage != null;

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QR Code Card
                Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // QR Code
                          hasContent
                              ? _buildQrCode(qrImage, provider.options)
                              : _buildEmptyState(theme),

                          const SizedBox(height: 24),

                          // Actions
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Share Button
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: hasContent && !_isExporting
                                      ? _handleShare
                                      : null,
                                  icon: const Icon(
                                    Icons.share_rounded,
                                    size: 18,
                                  ),
                                  label: const Text('Share'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Download Button
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: hasContent && !_isExporting
                                      ? _handleDownload
                                      : null,
                                  icon: _isExporting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.download_rounded,
                                          size: 18,
                                        ),
                                  label: const Text('Save'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.easeOutBack)
                    .fadeIn(duration: 400.ms),

                // Info Badge
                if (hasContent) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${provider.data.type.name.toUpperCase()} • ${content.length} chars',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.5, end: 0),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQrCode(QrImage qrImage, dynamic options) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic size
        // Max 400, or 80% of screen width if smaller
        final screenWidth = MediaQuery.of(context).size.width;
        final maxAllowedSize = (screenWidth * 0.8).clamp(200.0, 400.0);

        return RepaintBoundary(
          key: _qrKey,
          child: Container(
            width: maxAllowedSize,
            height: maxAllowedSize,
            decoration: BoxDecoration(
              color: options.backgroundColor,
              // Removed borderRadius to ensure sharp corners for QR code
            ),
            child: CustomPaint(
              size: Size(maxAllowedSize, maxAllowedSize),
              painter: QrPainter(
                qrImage: qrImage,
                options: options,
                logoImage: _logoImage,
              ),
            ),
          ),
        ).animate(target: 1).fadeIn(duration: 500.ms);
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 2.seconds,
              ),
          const SizedBox(height: 24),
          Text(
            'Ready to Generate',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter content to see preview',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
