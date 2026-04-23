import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/qr_options.dart';
import '../../providers/qr_provider.dart';
import '../../utils/translations.dart';
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header title
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t('customize_design'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      context.t('personalize_qr'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              // ============================================
              // Section: Size
              // ============================================
              _SectionHeader(
                title: context.t('style_size'),
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
                title: Text(context.t('style_antialiasing')),
                subtitle: Text(context.t('antialiasing_desc')),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              // ============================================
              // Section: Shapes
              // ============================================
              _SectionHeader(
                title: context.t('style_shape_title'),
                icon: Icons.category_rounded,
              ),
              ShapeSelector<QrDotShape>(
                label: context.t('style_dot_shape'),
                value: options.dotShape,
                items: QrDotShape.values,
                onChanged: (shape) {
                  if (shape != null) provider.updateDotShape(shape);
                },
              ),
              ShapeSelector<QrEyeFrameShape>(
                label: context.t('style_eye_frame'),
                value: options.eyeFrameShape,
                items: QrEyeFrameShape.values,
                onChanged: (shape) {
                  if (shape != null) provider.updateEyeFrameShape(shape);
                },
              ),
              ShapeSelector<QrEyeBallShape>(
                label: context.t('style_eye_ball'),
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
              _SectionHeader(
                title: context.t('style_color_title'),
                icon: Icons.palette_rounded,
              ),
              const SizedBox(height: 8),
              ColorPickerTile(
                label: context.t('style_dots'),
                color: options.dotColor,
                onChanged: provider.updateDotColor,
              ),
              const SizedBox(height: 12),
              ColorPickerTile(
                label: context.t('style_eye_frame_color'),
                color: options.eyeFrameColor,
                onChanged: provider.updateEyeFrameColor,
              ),
              const SizedBox(height: 12),
              ColorPickerTile(
                label: context.t('style_eye_ball_color'),
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
                    Expanded(
                      child: Text(
                        context.t('eye_ball_warning'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ColorPickerTile(
                label: context.t('style_bg'),
                color: options.backgroundColor,
                onChanged: provider.updateBackgroundColor,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              // ============================================
              // Section: Logo/Image
              // ============================================
              _SectionHeader(
                title: context.t('style_logo_title'),
                icon: Icons.image_rounded,
              ),
              const SizedBox(height: 8),
              _LogoSection(
                imagePath: options.imagePath,
                imageMargin: options.imageMargin,
                onImagePicked: provider.updateImagePath,
                onMarginChanged: provider.updateImageMargin,
              ),
              const SizedBox(height: 32),
            ],
          ),
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
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 12),
              Text(context.t('warning_color_title')),
            ],
          ),
          content: Text(context.t('warning_color_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t('cancel_change')),
            ),
            FilledButton(
              onPressed: () {
                provider.updateEyeBallColor(color);
                Navigator.pop(context);
              },
              child: Text(context.t('keep_color')),
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
                context.t('size'),
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
            content: Text('${context.t('pick_image_failed')}: $e'),
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
              label: Text(context.t('style_logo_choose')),
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
                        context.t('logo_active'),
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
                      tooltip: context.t('change_image'),
                    ),
                    const SizedBox(width: 4),
                    // Remove Image
                    IconButton.filledTonal(
                      onPressed: () => onImagePicked(null),
                      icon: const Icon(Icons.delete_rounded, size: 20),
                      tooltip: context.t('remove_image'),
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
            Text(context.t('style_margin'), style: theme.textTheme.bodyMedium),
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
              Expanded(
                child: Text(
                  context.t('style_error_level'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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
                label: Text(
                  level.name.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            selected: {value},
            onSelectionChanged: (newSelection) {
              onChanged(newSelection.first);
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.t('error_level_hint'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}