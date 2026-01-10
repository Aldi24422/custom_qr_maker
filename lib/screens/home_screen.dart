import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/qr_provider.dart';
import 'components/settings_panel.dart';
import 'components/styling_settings_panel.dart';
import 'components/qr_preview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPanel = 0; // 0 = Content, 1 = Style

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use a slightly lower breakpoint for tablet to accommodate foldable
    if (screenWidth >= 900) {
      return _buildDesktopLayout(context);
    } else if (screenWidth >= 600) {
      return _buildTabletLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Container(
            width: 450,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: _buildControlPanel(context),
          ),
          Expanded(child: _buildPreviewArea(context)),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: _buildControlPanel(context),
          ),
          Expanded(child: _buildPreviewArea(context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('QR Studio'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => _handleReset(context),
            tooltip: 'Reset All',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Preview Area (Adaptive height)
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: _buildPreviewArea(context),
              ),
            ),

            // Content Area
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.white,
                child: _selectedPanel == 0
                    ? const SettingsPanel(key: ValueKey('content'))
                    : const StylingSettingsPanel(key: ValueKey('style')),
              ).animate().fadeIn(duration: 300.ms),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPanel,
        onDestinationSelected: (index) =>
            setState(() => _selectedPanel = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note_rounded),
            label: 'Content',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette_rounded),
            label: 'Style',
          ),
        ],
      ),
    );
  }

  void _handleReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Everything?'),
        content: const Text(
          'This will clear all your current changes. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<QrProvider>().resetAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Reset complete')));
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'QR Studio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () => _handleReset(context),
                tooltip: 'Reset All',
              ),
            ],
          ),
        ),

        // Tab Selector (Desktop/Tablet)
        Padding(
          padding: const EdgeInsets.all(20),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text('Content'),
                icon: Icon(Icons.edit_note_rounded),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Style'),
                icon: Icon(Icons.palette_outlined),
              ),
            ],
            selected: {_selectedPanel},
            onSelectionChanged: (newSelection) {
              setState(() => _selectedPanel = newSelection.first);
            },
            style: const ButtonStyle(visualDensity: VisualDensity.comfortable),
          ),
        ),

        // Panel Content
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.05, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: _selectedPanel == 0
                ? const SettingsPanel(key: ValueKey('content'))
                : const StylingSettingsPanel(key: ValueKey('style')),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewArea(BuildContext context) {
    return const QrPreview();
  }
}
