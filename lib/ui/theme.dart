import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CozyTheme {
  // Colors
  static const Color postalRed = Color(0xFFFF6B6B);
  static const Color inkBlue = Color(0xFF2D3436);
  static const Color paperCream = Color(0xFFFDFBF7);
  static const Color meadowGreen = Color(0xFF6BCB77);
  static const Color skyBlue = Color(0xFF4D96FF);
  static const Color cautionYellow = Color(0xFFFFD93D);
  static const Color outlineGrey = Color(0xFFB2BEC3);
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.15);

  // Text Styles
  static TextStyle get headingStyle => GoogleFonts.mali(
    color: inkBlue,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get subheadingStyle => GoogleFonts.mali(
    color: inkBlue,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle get bodyStyle => GoogleFonts.mali(
    color: inkBlue,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get buttonTextStyle => GoogleFonts.mali(
    color: inkBlue,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get captionStyle => GoogleFonts.mali(
    color: inkBlue,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

