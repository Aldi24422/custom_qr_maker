import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';
import '../../utils/translations.dart';

enum WifiEncryption {
  wpa('wifi_enc_wpa', 'WPA'),
  wep('wifi_enc_wep', 'WEP'),
  none('wifi_enc_none', 'nopass');

  final String labelKey;
  final String value;
  const WifiEncryption(this.labelKey, this.value);
}

class WifiForm extends StatefulWidget {
  const WifiForm({super.key});

  @override
  State<WifiForm> createState() => _WifiFormState();
}

class _WifiFormState extends State<WifiForm> {
  late TextEditingController _ssidController;
  late TextEditingController _passwordController;
  WifiEncryption _encryption = WifiEncryption.wpa;
  bool _obscurePassword = true;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _ssidController = TextEditingController();
    _passwordController = TextEditingController();

    final provider = context.read<QrProvider>();
    if (provider.data.type == QrDataType.wifi &&
        provider.data.content.isNotEmpty) {
      _parseWifiString(provider.data.content);
    }
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _parseWifiString(String wifiString) {
    final regex = RegExp(r'WIFI:T:(\w*);S:([^;]*);P:([^;]*);H:(\w*);;');
    final match = regex.firstMatch(wifiString);
    if (match != null) {
      final encType = match.group(1) ?? 'WPA';
      _ssidController.text = match.group(2) ?? '';
      _passwordController.text = match.group(3) ?? '';
      _isHidden = match.group(4) == 'true';

      _encryption = WifiEncryption.values.firstWhere(
        (e) => e.value.toLowerCase() == encType.toLowerCase(),
        orElse: () => WifiEncryption.wpa,
      );
    }
  }

  String _generateWifiString() {
    final ssid = _ssidController.text;
    final password = _passwordController.text;
    return 'WIFI:T:${_encryption.value};S:$ssid;P:$password;H:$_isHidden;;';
  }

  void _updateProvider() {
    context.read<QrProvider>().updateContent(_generateWifiString());
  }

  @override
  Widget build(BuildContext context) {
    context.select<QrProvider, String>((p) => p.language);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = (screenWidth * 0.05).clamp(16.0, 32.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.wifi,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.t('type_wifi'),
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
            context.t('form_wifi_desc'),
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // SSID
          TextFormField(
            controller: _ssidController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: context.t('form_wifi_ssid'),
              labelStyle: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.router,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (_) => _updateProvider(),
          ),
          const SizedBox(height: 12),

          // Encryption
          DropdownButtonFormField<WifiEncryption>(
            initialValue: _encryption,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: context.t('form_wifi_encryption'),
              labelStyle: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.lock,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            items: WifiEncryption.values.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(
                  context.t(e.labelKey),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _encryption = value);
                _updateProvider();
              }
            },
          ),
          const SizedBox(height: 12),

          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: context.t('form_wifi_password'),
              labelStyle: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.password,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (_) => _updateProvider(),
          ),
          const SizedBox(height: 12),

          // Hidden Network
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t('form_wifi_hidden'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    context.t('form_wifi_hidden_hint'),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isHidden,
                onChanged: (value) {
                  setState(() => _isHidden = value);
                  _updateProvider();
                },
              ),
            ],
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
                    context.t('form_wifi_info'),
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
      ),
    );
  }
}