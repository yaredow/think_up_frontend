import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define the light theme
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 30,
          fontStyle: FontStyle.normal,
        ),
        bodyMedium: GoogleFonts.roboto(fontSize: 16),
        bodySmall: GoogleFonts.roboto(fontSize: 14),
      ),
      useMaterial3: true,
    );
  }

  // Define the dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 30,
          fontStyle: FontStyle.normal,
        ),
        bodyMedium: GoogleFonts.roboto(fontSize: 16),
        bodySmall: GoogleFonts.roboto(fontSize: 14),
      ),
      useMaterial3: true,
    );
  }
}
