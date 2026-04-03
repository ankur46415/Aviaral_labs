import 'package:flutter/material.dart';

class AppColors {
  static const List<Color> avatarPalette = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43C6AC),
    Color(0xFFFF9A3C),
    Color(0xFF4ECDC4),
    Color(0xFFF7797D),
  ];

  static Color getAvatarColor(String name) {
    if (name.isEmpty) return avatarPalette[0];
    return avatarPalette[name.codeUnitAt(0) % avatarPalette.length];
  }

  static const Color lightBg = Color(0xFFF5F6FA);
  static const Color darkBg = Color(0xFF0F0F14);

  static const Color white = Colors.white;
  static Color darkSurface = Colors.white.withOpacity(0.06);
  
  static Color getGreyAction(bool isDark) => isDark ? Colors.grey.shade400 : Colors.grey.shade500;
}
