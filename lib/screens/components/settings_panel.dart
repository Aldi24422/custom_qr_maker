import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';
import '../../widgets/forms/url_form.dart';
import '../../widgets/forms/text_form.dart';
import '../../widgets/forms/wifi_form.dart';
import '../../widgets/forms/email_form.dart';
import '../../widgets/forms/vcard_form.dart';
import '../../utils/translations.dart';

class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  int _selectedIndex = 0;

  static const List<QrDataType> _dataTypes = [
    QrDataType.url,
    QrDataType.text,
    QrDataType.wifi,
    QrDataType.vcard,
    QrDataType.email,
  ];

  void _onTypeSelected(int index) {
    setState(() => _selectedIndex = index);
    final provider = context.read<QrProvider>();
    if (provider.data.type != _dataTypes[index]) {
      provider.updateDataType(_dataTypes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.select<QrProvider, String>((p) => p.language);
    final theme = Theme.of(context);

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
                  context.t('content_type'),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  context.t('choose_qr_format'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Type Selector Grid (Responsive)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            children: List.generate(
              _dataTypes.length,
              (index) => _buildTypeItem(context, index),
            ),
          ),

          const SizedBox(height: 24),

          // Input Details Header
          Text(
            context.t('input_details'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildForm(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(int index) {
    switch (index) {
      case 0:
        return const UrlForm(key: ValueKey('url'));
      case 1:
        return const TextForm(key: ValueKey('text'));
      case 2:
        return const WifiForm(key: ValueKey('wifi'));
      case 3:
        return const VCardForm(key: ValueKey('vcard'));
      case 4:
        return const EmailForm(key: ValueKey('email'));
      default:
        return const UrlForm(key: ValueKey('url'));
    }
  }

  Widget _buildTypeItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final type = _dataTypes[index];
    final isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTypeSelected(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                type.icon,
                size: 24,
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                context.t(type.labelKey),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}