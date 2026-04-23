import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qr_provider.dart';
import 'components/settings_panel.dart';
import 'components/styling_settings_panel.dart';
import 'components/qr_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/translations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPanel = 0; // 0 = Content, 1 = Style

  @override
  Widget build(BuildContext context) {
    context.select<QrProvider, String>((p) => p.language);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildPremiumAppBar(context),
      body: screenWidth >= 1024
          ? _buildDesktopLayout(context)
          : (screenWidth >= 600
              ? _buildTabletLayout(context)
              : _buildMobileLayout(context)),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Custom QR maker by ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          InkWell(
            onTap: () async {
              final url = Uri.parse('https://anno-tech24.vercel.app/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Text(
              'AnnoTech',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar(BuildContext context) {
    final theme = Theme.of(context);
    // ✅ Perbaikan: gunakan brightness aktual dari tema, bukan dari provider
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(context.t('app_title')),
      centerTitle: false,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(color: Colors.transparent),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.language_rounded),
          color: theme.colorScheme.onSurfaceVariant,
          onPressed: () => context.read<QrProvider>().toggleLanguage(),
          tooltip: context.t('tooltip_lang'),
        ),
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            final provider = context.read<QrProvider>();
            // Toggle antara mode terang dan gelap, abaikan System untuk sementara
            provider.updateThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
          },
          tooltip: context.t('tooltip_theme'),
        ),
        IconButton(
          icon: Icon(
            Icons.refresh_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () => _handleReset(context),
          tooltip: context.t('tooltip_reset'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Input Details (Scrollable)
              SizedBox(
                width: 340,
                child: SingleChildScrollView(
                  child: const SettingsPanel(key: ValueKey('content')),
                ),
              ),
              const SizedBox(width: 32),

              // Center Column: QR Preview
              const Expanded(child: QrPreview()),

              const SizedBox(width: 32),

              // Right Column: Styling (Scrollable to prevent overflow)
              SizedBox(
                width: 340,
                child: SingleChildScrollView(
                  child: const StylingSettingsPanel(key: ValueKey('style')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left sidebar with scrollable content
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Column(
            children: [
              _buildTabletMobileTabSelector(context),
              Expanded(
                child: SingleChildScrollView(
                  child: _selectedPanel == 0
                      ? const SettingsPanel(key: ValueKey('content'))
                      : const StylingSettingsPanel(key: ValueKey('style')),
                ),
              ),
            ],
          ),
        ),
        // Preview area scrollable
        Expanded(
          child: SingleChildScrollView(
            child: const QrPreview(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview Area
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: const QrPreview(),
          ),

          // Tabs
          _buildTabletMobileTabSelector(context),

          // Content Area (Scrollable within the outer scroll)
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.only(bottom: 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedPanel == 0
                  ? const SettingsPanel(key: ValueKey('content'))
                  : const StylingSettingsPanel(key: ValueKey('style')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletMobileTabSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<int>(
        segments: [
          ButtonSegment(
            value: 0,
            label: Text(
              context.t('tab_content'),
              style: const TextStyle(fontSize: 13),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            icon: const Icon(Icons.edit_note_rounded, size: 18),
          ),
          ButtonSegment(
            value: 1,
            label: Text(
              context.t('tab_style'),
              style: const TextStyle(fontSize: 13),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            icon: const Icon(Icons.palette_outlined, size: 18),
          ),
        ],
        selected: {_selectedPanel},
        onSelectionChanged: (newSelection) {
          setState(() => _selectedPanel = newSelection.first);
        },
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
        ),
      ),
    );
  }

  void _handleReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t('reset_dialog_title')),
        content: Text(context.t('reset_dialog_content')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<QrProvider>().resetAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.t('reset_success'))),
              );
            },
            child: Text(context.t('reset')),
          ),
        ],
      ),
    );
  }
}