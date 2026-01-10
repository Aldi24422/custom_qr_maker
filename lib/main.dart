import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/qr_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final provider = QrProvider();
  await provider.init();

  runApp(
    ChangeNotifierProvider.value(value: provider, child: const QrMakerApp()),
  );
}

class QrMakerApp extends StatelessWidget {
  const QrMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Studio',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    // Professional Light Color Palette
    const bg = Color(0xFFF8FAFC); // Light gray background
    const surface = Colors.white; // Pure white cards
    const primary = Color(0xFF2563EB); // Professional blue
    const primaryLight = Color(0xFFDBEAFE); // Light blue for hover
    const textPrimary = Color(0xFF0F172A); // Very dark slate - max contrast
    const textSecondary = Color(0xFF475569); // Darker gray for secondary
    const border = Color(0xFFE2E8F0); // Light border

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.light(
        primary: primary,
        primaryContainer: primaryLight,
        surface: surface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        outline: border,
        outlineVariant: border,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
            titleLarge: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            titleMedium: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            titleSmall: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            bodyLarge: GoogleFonts.inter(color: textPrimary),
            bodyMedium: GoogleFonts.inter(color: textSecondary),
            bodySmall: GoogleFonts.inter(color: textSecondary, fontSize: 12),
            labelLarge: GoogleFonts.inter(
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: GoogleFonts.inter(color: textSecondary),
            labelSmall: GoogleFonts.inter(color: textSecondary, fontSize: 11),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: textSecondary,
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerHeight: 1,
        dividerColor: border,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 0,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: border,
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.1),
        trackHeight: 4,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: textSecondary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
