import 'package:flutter/material.dart';

/// Widget generic untuk memilih bentuk/shape dari dropdown
/// Digunakan untuk memilih berbagai shape seperti QrDotShape, QrEyeFrameShape, dll.
class ShapeSelector<T extends Enum> extends StatelessWidget {
  /// Label judul dropdown (misal: "Dot Shape")
  final String label;

  /// Nilai enum saat ini yang terpilih
  final T value;

  /// Daftar semua pilihan enum yang tersedia
  final List<T> items;

  /// Callback yang dipanggil saat nilai berubah
  final ValueChanged<T?> onChanged;

  const ShapeSelector({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  /// Memformat nama enum menjadi teks yang rapi
  /// Contoh: QrDotShape.extraRounded => "Extra Rounded"
  String _formatEnumName(T enumValue) {
    // Ambil nama enum setelah titik (misal: "extraRounded" dari "QrDotShape.extraRounded")
    final name = enumValue.name;

    // Pisahkan berdasarkan huruf kapital (camelCase ke words)
    final words = name.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );

    // Kapitalisasi huruf pertama setiap kata
    return words
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLowest,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        dropdownColor: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              _formatEnumName(item),
              style: theme.textTheme.bodyLarge,
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
