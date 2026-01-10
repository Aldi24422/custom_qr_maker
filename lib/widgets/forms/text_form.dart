import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';

/// Form input untuk Text (multiline)
class TextForm extends StatefulWidget {
  const TextForm({super.key});

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<QrProvider>();
    final initialValue = provider.data.type == QrDataType.text
        ? provider.data.content
        : '';
    _controller = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = (screenWidth * 0.05).clamp(16.0, 32.0);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.text_fields, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Teks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan teks bebas yang ingin di-encode ke dalam QR Code',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Input Field - Multiline
        TextFormField(
          controller: _controller,
          maxLines: 5,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Teks',
            labelStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            hintText: 'Ketik teks Anda di sini...',
            hintStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            alignLabelWithHint: true,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (value) {
            context.read<QrProvider>().updateContent(value);
          },
        ),

        const SizedBox(height: 8),

        // Character count
        Consumer<QrProvider>(
          builder: (context, provider, child) {
            final charCount = provider.data.content.length;
            final isNearLimit = charCount > 2000;

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  isNearLimit
                      ? Icons.warning_amber
                      : Icons.check_circle_outline,
                  size: 14,
                  color: isNearLimit
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '$charCount karakter',
                  style: TextStyle(
                    fontSize: 12,
                    color: isNearLimit
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 12),

        // Info hint
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Semakin panjang teks, semakin kompleks QR Code yang dihasilkan',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
