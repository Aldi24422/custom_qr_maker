import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_options.dart';
import '../models/qr_data.dart';

/// Provider untuk mengelola state QR Code Generator
/// Menggunakan ChangeNotifier untuk reactivity dengan Provider package
class QrProvider extends ChangeNotifier {
  // Private state
  QrOptions _options = const QrOptions();
  QrData _data = const QrData();

  // SharedPreferences key
  static const String _storageKey = 'qr_style_prefs';

  // Debounce timer for save operations
  Timer? _saveDebouncer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  // Getters
  QrOptions get options => _options;
  QrData get data => _data;

  // ============================================
  // Initialization & Persistence
  // ============================================

  /// Initialize provider with stored preferences
  /// Call this in main.dart or app startup
  Future<void> init() async {
    await loadFromStorage();
  }

  /// Schedule a debounced save to SharedPreferences
  void _scheduleSave() {
    _saveDebouncer?.cancel();
    _saveDebouncer = Timer(_debounceDuration, saveToStorage);
  }

  /// Save current options to SharedPreferences
  Future<void> saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_options.toJson());
      await prefs.setString(_storageKey, jsonString);
      debugPrint('QrProvider: Options saved to storage');
    } catch (e) {
      debugPrint('QrProvider: Error saving to storage: $e');
    }
  }

  /// Load options from SharedPreferences
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _options = QrOptions.fromJson(json);
        notifyListeners();
        debugPrint('QrProvider: Options loaded from storage');
      }
    } catch (e) {
      debugPrint('QrProvider: Error loading from storage: $e');
      // Keep default options on error
    }
  }

  /// Clear stored preferences
  Future<void> clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      debugPrint('QrProvider: Storage cleared');
    } catch (e) {
      debugPrint('QrProvider: Error clearing storage: $e');
    }
  }

  @override
  void dispose() {
    _saveDebouncer?.cancel();
    _contentDebouncer?.cancel();
    super.dispose();
  }

  // ============================================
  // QrOptions Setters (with debounced auto-save)
  // ============================================

  /// Helper method to update options and schedule save
  void _updateOptionsAndSave(QrOptions Function(QrOptions) updater) {
    _options = updater(_options);
    notifyListeners();
    _scheduleSave(); // Debounced save
  }

  /// Update ukuran QR Code
  void updateSize(double size) {
    _updateOptionsAndSave((opts) => opts.copyWith(size: size));
  }

  /// Update margin untuk embedded image/logo
  void updateImageMargin(double margin) {
    _updateOptionsAndSave((opts) => opts.copyWith(imageMargin: margin));
  }

  /// Update bentuk dot pattern
  void updateDotShape(QrDotShape shape) {
    _updateOptionsAndSave((opts) => opts.copyWith(dotShape: shape));
  }

  /// Update bentuk frame mata QR
  void updateEyeFrameShape(QrEyeFrameShape shape) {
    _updateOptionsAndSave((opts) => opts.copyWith(eyeFrameShape: shape));
  }

  /// Update bentuk bola mata QR
  void updateEyeBallShape(QrEyeBallShape shape) {
    _updateOptionsAndSave((opts) => opts.copyWith(eyeBallShape: shape));
  }

  /// Update warna dot pattern
  void updateDotColor(Color color) {
    _updateOptionsAndSave((opts) => opts.copyWith(dotColor: color));
  }

  /// Update warna frame mata QR
  void updateEyeFrameColor(Color color) {
    _updateOptionsAndSave((opts) => opts.copyWith(eyeFrameColor: color));
  }

  /// Update warna bola mata QR
  void updateEyeBallColor(Color color) {
    _updateOptionsAndSave((opts) => opts.copyWith(eyeBallColor: color));
  }

  /// Update warna background QR
  void updateBackgroundColor(Color color) {
    _updateOptionsAndSave((opts) => opts.copyWith(backgroundColor: color));
  }

  /// Update error correction level
  void updateErrorLevel(QrErrorLevel level) {
    _updateOptionsAndSave((opts) => opts.copyWith(errorLevel: level));
  }

  /// Update path untuk embedded image/logo
  void updateImagePath(String? path) {
    _updateOptionsAndSave((opts) => opts.copyWith(imagePath: path));
  }

  /// Clear image path (remove logo)
  void clearImagePath() {
    _updateOptionsAndSave((opts) => opts.copyWith(imagePath: null));
  }

  /// Toggle remove brand option
  void updateRemoveBrand(bool remove) {
    _updateOptionsAndSave((opts) => opts.copyWith(removeBrand: remove));
  }

  /// Toggle anti-aliasing option
  void updateEnableAntialiasing(bool enable) {
    _updateOptionsAndSave((opts) => opts.copyWith(enableAntialiasing: enable));
  }

  /// Update semua warna sekaligus
  void updateAllColors({
    Color? dotColor,
    Color? eyeFrameColor,
    Color? eyeBallColor,
    Color? backgroundColor,
  }) {
    _updateOptionsAndSave(
      (opts) => opts.copyWith(
        dotColor: dotColor,
        eyeFrameColor: eyeFrameColor,
        eyeBallColor: eyeBallColor,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Reset options ke default
  void resetOptions() {
    _saveDebouncer?.cancel();
    _options = const QrOptions();
    notifyListeners();
    clearStorage(); // Clear storage when reset
  }

  // ============================================
  // QrData Setters
  // ============================================

  /// Update tipe data QR
  void updateDataType(QrDataType type) {
    _data = _data.copyWith(type: type);
    notifyListeners();
  }

  // Debounce timer for content updates (QR generation)
  Timer? _contentDebouncer;

  /// Update konten/data yang akan di-encode
  /// Menggunakan debounce untuk mencegah lag saat mengetik
  void updateContent(String content) {
    _contentDebouncer?.cancel();
    _contentDebouncer = Timer(const Duration(milliseconds: 300), () {
      _data = _data.copyWith(content: content);
      notifyListeners();
    });
  }

  /// Update tipe dan konten sekaligus
  void updateData({QrDataType? type, String? content}) {
    _data = _data.copyWith(type: type, content: content);
    notifyListeners();
  }

  /// Reset data ke default
  void resetData() {
    _data = const QrData();
    notifyListeners();
  }

  // ============================================
  // Combined Operations
  // ============================================

  /// Reset semua state ke default
  void resetAll() {
    _saveDebouncer?.cancel();
    _options = const QrOptions();
    _data = const QrData();
    notifyListeners();
    clearStorage();
  }

  /// Cek apakah QR siap untuk di-generate
  bool get isReadyToGenerate => _data.isValid;
}
