import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/qr_data.dart';
import '../../providers/qr_provider.dart';
import '../../widgets/forms/url_form.dart';
import '../../widgets/forms/text_form.dart';
import '../../widgets/forms/wifi_form.dart';
import '../../widgets/forms/email_form.dart';
import '../../widgets/forms/vcard_form.dart';

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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Type Selector - Adaptive
        LayoutBuilder(
          builder: (context, constraints) {
            // Use Wrap for smaller screens (mobile) to show all options at once if possible without scrolling
            // Or use ListView for wider screens or if there are too many items
            if (constraints.maxWidth < 600) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.dividerColor)),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_dataTypes.length, (index) {
                    return _buildTypeItem(context, index, isCompact: true);
                  }),
                ),
              );
            }

            // Desktop/Tablet - Horizontal List
            return Container(
              height: 72,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.dividerColor)),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                itemCount: _dataTypes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _buildTypeItem(context, index),
              ),
            );
          },
        ),

        // Form Content with smooth animation
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildForm(_selectedIndex),
          ),
        ),
      ],
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

  Widget _buildTypeItem(
    BuildContext context,
    int index, {
    bool isCompact = false,
  }) {
    final theme = Theme.of(context);
    final type = _dataTypes[index];
    final isSelected = _selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onTypeSelected(index),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 18,
            vertical: isCompact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(isCompact ? 8 : 10),
            border: isSelected ? null : Border.all(color: theme.dividerColor),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type.icon,
                size: isCompact ? 16 : 18,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: isCompact ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
