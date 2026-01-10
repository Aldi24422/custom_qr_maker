import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _bodyController = TextEditingController();

    final provider = context.read<QrProvider>();
    if (provider.data.type == QrDataType.email &&
        provider.data.content.isNotEmpty) {
      _parseEmailString(provider.data.content);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _parseEmailString(String emailString) {
    final content = emailString.startsWith('mailto:')
        ? emailString.substring(7)
        : emailString;
    final uri = Uri.tryParse('mailto:$content');
    if (uri != null) {
      _emailController.text = uri.path;
      _subjectController.text = uri.queryParameters['subject'] ?? '';
      _bodyController.text = uri.queryParameters['body'] ?? '';
    }
  }

  String _generateEmailString() {
    final email = _emailController.text;
    final subject = _subjectController.text;
    final body = _bodyController.text;

    final params = <String, String>{};
    if (subject.isNotEmpty) params['subject'] = subject;
    if (body.isNotEmpty) params['body'] = body;

    if (params.isEmpty) return email;

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$email?$queryString';
  }

  void _updateProvider() {
    context.read<QrProvider>().updateContent(_generateEmailString());
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value)) return 'Masukkan email yang valid';
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
            Icon(Icons.email, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Email',
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
          'Buat QR Code untuk mengirim email',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Alamat Email',
            labelStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            hintText: 'contoh@email.com',
            prefixIcon: Icon(
              Icons.alternate_email,
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
          validator: _validateEmail,
          onChanged: (_) => _updateProvider(),
        ),
        const SizedBox(height: 12),

        // Subject
        TextFormField(
          controller: _subjectController,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Subjek (Opsional)',
            labelStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              Icons.subject,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (_) => _updateProvider(),
        ),
        const SizedBox(height: 12),

        // Body
        TextFormField(
          controller: _bodyController,
          maxLines: 3,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Isi Pesan (Opsional)',
            labelStyle: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.message,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (_) => _updateProvider(),
        ),
        const SizedBox(height: 12),

        // Info
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
                  'Scan untuk membuka aplikasi email dengan data terisi',
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
