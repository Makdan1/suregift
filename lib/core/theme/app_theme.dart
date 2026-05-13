import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, state.index);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}

class AppTheme {
  static const primaryColor = Color(0xFFE61E26);
  static const secondaryColor = Color(0xFF2D2E49);
  static const accentColor = Color(0xFFE61E26);
  
  // Light Theme Colors
  static const backgroundColor = Color(0xFFF8F9FD);
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF1A1A1A);
  static const subTextColor = Color(0xFF757575);

  // Dark Theme Colors
  static const darkBackgroundColor = Color(0xFF0F1014);
  static const darkCardColor = Color(0xFF1C1D21);
  static const darkTextColor = Color(0xFFF5F5F5);
  static const darkSubTextColor = Color(0xFFA0A0A0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, color: textColor),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, color: subTextColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      iconTheme: const IconThemeData(color: textColor),
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme(isDark: false),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: subTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkCardColor,
      background: darkBackgroundColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextColor),
      titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextColor),
      bodyLarge: GoogleFonts.outfit(fontSize: 16, color: darkTextColor),
      bodyMedium: GoogleFonts.outfit(fontSize: 14, color: darkSubTextColor),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: darkTextColor),
      iconTheme: const IconThemeData(color: darkTextColor),
    ),
    elevatedButtonTheme: _elevatedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme(isDark: true),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCardColor,
      selectedItemColor: Colors.white, // Made active item white for better visibility in dark mode
      unselectedItemColor: darkSubTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) => InputDecorationTheme(
    filled: true,
    fillColor: isDark ? const Color(0xFF25262B) : Colors.grey[100],
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    hintStyle: GoogleFonts.outfit(color: isDark ? darkSubTextColor : subTextColor),
  );
}
