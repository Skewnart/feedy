import 'package:flutter/material.dart';

class ColorService {
  final Color primaryColor = const Color(0xFF779141);
  final Color secondaryColor = const Color(0xFFDCE7B9);
  final Color tertiaryColor = const Color(0xFFD09126);
  final Color _standardBG = const Color(0xFFFAFAFA);

  final Color highGauge = Colors.green;
  final Color middleGauge = Colors.orange;
  final Color lowGauge = Colors.red;

  late final ColorScheme scheme;

  ColorService() {
    scheme = ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: primaryColor,
        tertiary: tertiaryColor,
        onTertiary: primaryColor,
        error: primaryColor,
        onError: Colors.red,
        background: _standardBG,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black);
  }
}
