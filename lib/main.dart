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
    final themeMode = context.watch<QrProvider>().themeMode;
    return MaterialApp(
      title: 'Custom QR Maker',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    const bg = Color(0xFFF8F9FA); // background
    const surface = Color(0xFFFFFFFF); // surfaceContainerLowest
    const primary = Color(0xFF24389C); // primary (Indigo)
    const secondary = Color(0xFF14696D); // secondary (Teal)
    const textPrimary = Color(0xFF191C1D); // onSurface
    const textSecondary = Color(0xFF454652); // onSurfaceVariant
    const border = Color(0xFFE1E3E4); // surface-variant or outline-variant
    const surfaceContainerHigh = Color(0xFFE7E8E9);
    const surfaceContainerLowest = Color(0xFFFFFFFF);

    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);
    final manropeTextTheme = GoogleFonts.manropeTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        outline: border,
        surfaceContainerHighest: surfaceContainerHigh,
        surfaceContainerLowest: surfaceContainerLowest,
        primaryContainer: Color(0xFF3F51B5),
        onPrimaryContainer: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: manropeTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        displayMedium: manropeTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        displaySmall: manropeTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        headlineLarge: manropeTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        headlineMedium: manropeTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        headlineSmall: manropeTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        titleLarge: manropeTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: primary),
        titleMedium: manropeTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
        titleSmall: manropeTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textSecondary),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF00105C), // Deepest indigo
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // xl
          side: BorderSide.none, // We will use shadow instead of border
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // full
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textSecondary,
          side: const BorderSide(color: border),
          backgroundColor: surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999), // full
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
    );
  }

  ThemeData _buildDarkTheme() {
    const bg = Color(0xFF090A10); // Very dark blue/black
    const surface = Color(0xFF131522); // Slightly raised dark
    const primary = Color(0xFFBAC3FF); // primary-fixed-dim (Soft Indigo)
    const secondary = Color(0xFF8AD3D7); // secondary-fixed-dim (Soft Teal)
    const textPrimary = Color(0xFFF9FAFA); 
    const textSecondary = Color(0xFFA5A6B4); 
    const border = Color(0xFF282A3A); 
    const surfaceContainerHigh = Color(0xFF1A1C2C);
    const surfaceContainerLowest = Color(0xFF0C0E16);

    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    final manropeTextTheme = GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
        onSurfaceVariant: textSecondary,
        outline: border,
        surfaceContainerHighest: surfaceContainerHigh,
        surfaceContainerLowest: surfaceContainerLowest,
        primaryContainer: Color(0xFF24389C),
        onPrimaryContainer: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: manropeTextTheme.displayLarge?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        displayMedium: manropeTextTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        displaySmall: manropeTextTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
        headlineLarge: manropeTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        headlineMedium: manropeTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        headlineSmall: manropeTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5),
        titleLarge: manropeTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: primary),
        titleMedium: manropeTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
        titleSmall: manropeTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: textPrimary),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        labelMedium: baseTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        labelSmall: baseTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textSecondary),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide.none,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textSecondary,
          backgroundColor: surfaceContainerHigh,
          side: BorderSide.none, // Remove border for floating effect
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1, space: 0),
    );
  }
}

