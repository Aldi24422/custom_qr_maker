import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';

/// Form input untuk URL/Link
class UrlForm extends StatefulWidget {
  const UrlForm({super.key});

  @override
  State<UrlForm> createState() => _UrlFormState();
}

class _UrlFormState extends State<UrlForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = context.read<QrProvider>();
    final initialValue = provider.data.type == QrDataType.url
        ? provider.data.content
        : '';
    _controller = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\w\-]+(\.[\w\-]+)+)([\w\-.,@?^=%&:/~+#]*)*$',
      caseSensitive: false,
    );
    if (!urlPattern.hasMatch(value)) {
      return 'Masukkan URL yang valid';
    }
    return null;
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
            Icon(Icons.link, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'URL / Website',
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
          'Masukkan alamat website atau link yang ingin di-encode',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Input Field
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.url,
          autocorrect: false,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'URL',
            labelStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            hintText: 'https://example.com',
            hintStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              Icons.language,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _validateUrl,
          onChanged: (value) {
            context.read<QrProvider>().updateContent(value);
          },
        ),

        const SizedBox(height: 12),

        // Info hint
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Protokol https:// akan ditambahkan otomatis jika tidak ada',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
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
