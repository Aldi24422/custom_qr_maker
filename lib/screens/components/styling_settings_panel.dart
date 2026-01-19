import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/qr_options.dart';
import '../../providers/qr_provider.dart';
import '../../widgets/styling/color_picker_tile.dart';
import '../../widgets/styling/shape_selector.dart';

/// Panel utama untuk mengatur styling QR Code
/// Mencakup: Size, Shapes, Colors, dan Logo settings
class StylingSettingsPanel extends StatelessWidget {
  const StylingSettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QrProvider>(
      builder: (context, provider, child) {
        final options = provider.options;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ============================================
                  // Section: Size
                  // ============================================
                  _SectionHeader(
                    title: 'Ukuran',
                    icon: Icons.photo_size_select_large_rounded,
                  ),
                  _SizeSlider(
                    value: options.size,
                    onChanged: provider.updateSize,
                  ),
                  const SizedBox(height: 16),

                  // Error Correction Level
                  _ErrorLevelSelector(
                    value: options.errorLevel,
                    onChanged: provider.updateErrorLevel,
                  ),
                  const SizedBox(height: 16),

                  // Anti-Aliasing
                  SwitchListTile.adaptive(
                    value: options.enableAntialiasing,
                    onChanged: provider.updateEnableAntialiasing,
                    title: const Text('Anti-aliasing'),
                    subtitle: const Text('Haluskan tepi QR Code'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // ============================================
                  // Section: Shapes
                  // ============================================
                  _SectionHeader(title: 'Bentuk', icon: Icons.category_rounded),
                  ShapeSelector<QrDotShape>(
                    label: 'Dot Shape',
                    value: options.dotShape,
                    items: QrDotShape.values,
                    onChanged: (shape) {
                      if (shape != null) provider.updateDotShape(shape);
                    },
                  ),
                  ShapeSelector<QrEyeFrameShape>(
                    label: 'Eye Frame Shape',
                    value: options.eyeFrameShape,
                    items: QrEyeFrameShape.values,
                    onChanged: (shape) {
                      if (shape != null) provider.updateEyeFrameShape(shape);
                    },
                  ),
                  ShapeSelector<QrEyeBallShape>(
                    label: 'Eye Ball Shape',
                    value: options.eyeBallShape,
                    items: QrEyeBallShape.values,
                    onChanged: (shape) {
                      if (shape != null) provider.updateEyeBallShape(shape);
                    },
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // ============================================
                  // Section: Colors
                  // ============================================
                  _SectionHeader(title: 'Warna', icon: Icons.palette_rounded),
                  const SizedBox(height: 8),
                  ColorPickerTile(
                    label: 'Dot Color',
                    color: options.dotColor,
                    onChanged: provider.updateDotColor,
                  ),
                  const SizedBox(height: 12),
                  ColorPickerTile(
                    label: 'Eye Frame Color',
                    color: options.eyeFrameColor,
                    onChanged: provider.updateEyeFrameColor,
                  ),
                  const SizedBox(height: 12),
                  ColorPickerTile(
                    label: 'Eye Ball Color',
                    color: options.eyeBallColor,
                    onChanged: (color) =>
                        _checkAndUpdateEyeBallColor(context, color, provider),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 4, bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Gunakan warna gelap agar mudah discan',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ColorPickerTile(
                    label: 'Background Color',
                    color: options.backgroundColor,
                    onChanged: provider.updateBackgroundColor,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // ============================================
                  // Section: Logo/Image
                  // ============================================
                  _SectionHeader(title: 'Logo', icon: Icons.image_rounded),
                  const SizedBox(height: 8),
                  _LogoSection(
                    imagePath: options.imagePath,
                    imageMargin: options.imageMargin,
                    onImagePicked: provider.updateImagePath,
                    onMarginChanged: provider.updateImageMargin,
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.5;
  }

  void _checkAndUpdateEyeBallColor(
    BuildContext context,
    Color color,
    QrProvider provider,
  ) {
    if (_isLightColor(color)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 12),
              Text('Warna Terlalu Terang'),
            ],
          ),
          content: const Text(
            'Warna Eye Ball yang Anda pilih terlalu terang. \n\n'
            'QR Code membutuhkan kontras tinggi (Eye Ball gelap di atas background putih) agar bisa dibaca oleh scanner.\n\n'
            'Apakah Anda yakin ingin menggunakan warna ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal, Ganti Warna'),
            ),
            FilledButton(
              onPressed: () {
                provider.updateEyeBallColor(color);
                Navigator.pop(context);
              },
              child: const Text('Tetap Gunakan'),
            ),
          ],
        ),
      );
    } else {
      provider.updateEyeBallColor(color);
    }
  }
}

/// Header untuk setiap section
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Slider untuk mengatur ukuran QR Code
class _SizeSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _SizeSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Size',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${value.toInt()} px',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 500,
              max: 2000,
              divisions: 30,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '500 px',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '2000 px',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section untuk mengatur logo/image
class _LogoSection extends StatelessWidget {
  final String? imagePath;
  final double imageMargin;
  final ValueChanged<String?> onImagePicked;
  final ValueChanged<double> onMarginChanged;

  const _LogoSection({
    this.imagePath,
    required this.imageMargin,
    required this.onImagePicked,
    required this.onMarginChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 90,
      );

      if (image != null) {
        onImagePicked(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _getFileName(String path) {
    // Handle both file path separators
    if (path.contains('/')) {
      return path.split('/').last;
    } else if (path.contains('\\')) {
      return path.split('\\').last;
    }
    return path;
  }

  /// Build image preview widget that works on both web and mobile
  Widget _buildImagePreview(String path, ThemeData theme) {
    // On web, ImagePicker returns a blob: URL
    if (kIsWeb || path.startsWith('blob:') || path.startsWith('http')) {
      return Image.network(
        path,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(theme);
        },
      );
    }

    // For mobile/desktop, use File
    return Image.file(
      File(path),
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget(theme);
      },
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.broken_image_rounded,
        color: theme.colorScheme.onErrorContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upload / Preview Section
          if (imagePath == null) ...[
            // Upload Button
            OutlinedButton.icon(
              onPressed: () => _pickImage(context),
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Upload Image'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ] else ...[
            // Image Preview & Actions
            Row(
              children: [
                // Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImagePreview(imagePath!, theme),
                ),
                const SizedBox(width: 12),

                // File Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFileName(imagePath!),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Logo aktif',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  children: [
                    // Change Image
                    IconButton.filledTonal(
                      onPressed: () => _pickImage(context),
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      tooltip: 'Ganti gambar',
                    ),
                    const SizedBox(width: 4),
                    // Remove Image
                    IconButton.filledTonal(
                      onPressed: () => onImagePicked(null),
                      icon: const Icon(Icons.delete_rounded, size: 20),
                      tooltip: 'Hapus gambar',
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.errorContainer,
                        foregroundColor: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image Margin Slider
            _ImageMarginSlider(value: imageMargin, onChanged: onMarginChanged),
          ],
        ],
      ),
    );
  }
}

/// Slider untuk mengatur margin logo
class _ImageMarginSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ImageMarginSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Image Margin', style: theme.textTheme.bodyMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${value.toInt()} px',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.secondary,
            inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
            thumbColor: theme.colorScheme.secondary,
            overlayColor: theme.colorScheme.secondary.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 50,
            divisions: 50,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0 px',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '50 px',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Dropdown untuk memilih Error Correction Level
class _ErrorLevelSelector extends StatelessWidget {
  final QrErrorLevel value;
  final ValueChanged<QrErrorLevel> onChanged;

  const _ErrorLevelSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Error Correction', style: theme.textTheme.bodyLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  value.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<QrErrorLevel>(
            segments: QrErrorLevel.values.map((level) {
              return ButtonSegment(
                value: level,
                label: Text(level.name.toUpperCase()),
              );
            }).toList(),
            selected: {value},
            onSelectionChanged: (newSelection) {
              onChanged(newSelection.first);
            },
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
          ),
          const SizedBox(height: 8),
          Text(
            'Higher = better logo support, larger QR',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
