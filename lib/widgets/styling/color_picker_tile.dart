import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// Enhanced Color Picker tile with hex input support
/// Allows free color selection and manual hex code input
class ColorPickerTile extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const ColorPickerTile({
    super.key,
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showColorPickerDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
          color: theme.colorScheme.surfaceContainerLowest,
        ),
        child: Row(
          children: [
            // Color Preview
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Label and Hex Code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _colorToHex(color),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Edit Icon
            Icon(
              Icons.edit_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _colorToHex(Color color) {
    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hex.substring(2).toUpperCase()}';
  }

  Color? _hexToColor(String hex) {
    hex = hex.replaceAll('#', '').replaceAll('0x', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add alpha
    }
    if (hex.length == 8) {
      final intValue = int.tryParse(hex, radix: 16);
      if (intValue != null) {
        return Color(intValue);
      }
    }
    return null;
  }

  void _showColorPickerDialog(BuildContext context) {
    final theme = Theme.of(context);
    Color tempColor = color;
    final hexController = TextEditingController(text: _colorToHex(color));

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.palette_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Color Picker
                    ColorPicker(
                      pickerColor: tempColor,
                      onColorChanged: (newColor) {
                        setDialogState(() {
                          tempColor = newColor;
                          hexController.text = _colorToHex(newColor);
                        });
                      },
                      enableAlpha: false,
                      hexInputBar: false,
                      displayThumbColor: true,
                      pickerAreaHeightPercent: 0.7,
                      labelTypes: const [],
                    ),
                    const SizedBox(height: 16),
                    // Hex Input Field
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: hexController,
                            decoration: InputDecoration(
                              labelText: 'Kode Hex',
                              hintText: '#FF5722',
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: tempColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-fA-F#]'),
                              ),
                              LengthLimitingTextInputFormatter(7),
                            ],
                            onChanged: (value) {
                              final parsed = _hexToColor(value);
                              if (parsed != null) {
                                setDialogState(() {
                                  tempColor = parsed;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () async {
                            await Clipboard.getData('text/plain').then((data) {
                              if (data?.text != null) {
                                final parsed = _hexToColor(data!.text!);
                                if (parsed != null) {
                                  setDialogState(() {
                                    tempColor = parsed;
                                    hexController.text = _colorToHex(parsed);
                                  });
                                }
                              }
                            });
                          },
                          icon: const Icon(Icons.paste_rounded),
                          tooltip: 'Paste dari clipboard',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    onChanged(tempColor);
                    Navigator.pop(dialogContext);
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Pilih'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
