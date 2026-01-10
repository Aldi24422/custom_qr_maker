import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';

class VCardForm extends StatefulWidget {
  const VCardForm({super.key});

  @override
  State<VCardForm> createState() => _VCardFormState();
}

class _VCardFormState extends State<VCardForm> {
  late TextEditingController _nameController;
  late TextEditingController _orgController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _orgController = TextEditingController();
    _titleController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _websiteController = TextEditingController();
    _addressController = TextEditingController();

    final provider = context.read<QrProvider>();
    if (provider.data.type == QrDataType.vcard &&
        provider.data.content.isNotEmpty) {
      _parseVCardString(provider.data.content);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _parseVCardString(String vcard) {
    final lines = vcard.split('\n');
    for (final line in lines) {
      if (line.startsWith('FN:')) {
        _nameController.text = line.substring(3);
      } else if (line.startsWith('ORG:')) {
        _orgController.text = line.substring(4);
      } else if (line.startsWith('TITLE:')) {
        _titleController.text = line.substring(6);
      } else if (line.startsWith('TEL:')) {
        _phoneController.text = line.substring(4);
      } else if (line.startsWith('EMAIL:')) {
        _emailController.text = line.substring(6);
      } else if (line.startsWith('URL:')) {
        _websiteController.text = line.substring(4);
      } else if (line.startsWith('ADR:')) {
        _addressController.text = line.substring(4).replaceAll(';', ', ');
      }
    }
  }

  String _generateVCardString() {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCARD');
    buffer.writeln('VERSION:3.0');

    if (_nameController.text.isNotEmpty) {
      buffer.writeln('FN:${_nameController.text}');
      final nameParts = _nameController.text.split(' ');
      if (nameParts.length > 1) {
        buffer.writeln('N:${nameParts.last};${nameParts.first};;;');
      } else {
        buffer.writeln('N:${_nameController.text};;;;');
      }
    }
    if (_orgController.text.isNotEmpty) {
      buffer.writeln('ORG:${_orgController.text}');
    }
    if (_titleController.text.isNotEmpty) {
      buffer.writeln('TITLE:${_titleController.text}');
    }
    if (_phoneController.text.isNotEmpty) {
      buffer.writeln('TEL:${_phoneController.text}');
    }
    if (_emailController.text.isNotEmpty) {
      buffer.writeln('EMAIL:${_emailController.text}');
    }
    if (_websiteController.text.isNotEmpty) {
      buffer.writeln('URL:${_websiteController.text}');
    }
    if (_addressController.text.isNotEmpty) {
      buffer.writeln('ADR:;;${_addressController.text};;;;');
    }

    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  void _updateProvider() {
    context.read<QrProvider>().updateContent(_generateVCardString());
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
            Icon(
              Icons.contact_page,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'VCard / Kartu Kontak',
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
          'Buat QR Code untuk menyimpan kontak digital',
          style: TextStyle(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        _buildField(_nameController, 'Nama Lengkap', Icons.person),
        const SizedBox(height: 10),
        _buildField(_orgController, 'Perusahaan', Icons.business),
        const SizedBox(height: 10),
        _buildField(_titleController, 'Jabatan', Icons.work),
        const SizedBox(height: 10),
        _buildField(
          _phoneController,
          'Telepon',
          Icons.phone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 10),
        _buildField(
          _emailController,
          'Email',
          Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        _buildField(
          _websiteController,
          'Website',
          Icons.language,
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: 10),
        _buildField(_addressController, 'Alamat', Icons.location_on),
        const SizedBox(height: 12),

        // Info
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
                  'Scan untuk menyimpan kontak ke phonebook',
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

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 13,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          icon,
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
    );
  }
}
