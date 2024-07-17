import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;

  const AppColors._({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
  });

  factory AppColors.light() {
    return const AppColors._(
      background: Color.fromARGB(255, 255, 255, 255),
      foreground: Color.fromARGB(255, 12, 12, 12),
      card: Color.fromARGB(255, 255, 255, 255),
      cardForeground: Color.fromARGB(255, 12, 12, 12),
      popover: Color.fromARGB(255, 255, 255, 255),
      popoverForeground: Color.fromARGB(255, 12, 12, 12),
      primary: Color.fromARGB(255, 79, 129, 236),
      primaryForeground: Color.fromARGB(255, 249, 249, 249),
      secondary: Color.fromARGB(255, 244, 244, 244),
      secondaryForeground: Color.fromARGB(255, 12, 12, 12),
      muted: Color.fromARGB(255, 244, 244, 244),
      mutedForeground: Color.fromARGB(255, 114, 114, 114),
      accent: Color.fromARGB(255, 244, 244, 244),
      accentForeground: Color.fromARGB(255, 12, 12, 12),
      destructive: Color.fromARGB(255, 238, 67, 67),
      destructiveForeground: Color.fromARGB(255, 249, 249, 249),
      border: Color.fromARGB(255, 234, 234, 234),
      input: Color.fromARGB(255, 216, 216, 216),
      ring: Color.fromARGB(255, 193, 193, 193),
    );
  }

  factory AppColors.dark() {
    return const AppColors._(
      background: Color.fromARGB(255, 0, 0, 0),
      foreground: Color.fromARGB(255, 249, 249, 249),
      card: Color.fromARGB(255, 7, 7, 7),
      cardForeground: Color.fromARGB(255, 249, 249, 249),
      popover: Color.fromARGB(255, 7, 7, 7),
      popoverForeground: Color.fromARGB(255, 249, 249, 249),
      primary: Color.fromARGB(255, 79, 129, 236),
      primaryForeground: Color.fromARGB(255, 249, 249, 249),
      secondary: Color.fromARGB(255, 15, 15, 15),
      secondaryForeground: Color.fromARGB(255, 249, 249, 249),
      muted: Color.fromARGB(255, 22, 22, 22),
      mutedForeground: Color.fromARGB(255, 124, 124, 124),
      accent: Color.fromARGB(255, 15, 15, 15),
      accentForeground: Color.fromARGB(255, 249, 249, 249),
      destructive: Color.fromARGB(255, 238, 67, 67),
      destructiveForeground: Color.fromARGB(255, 249, 249, 249),
      border: Color.fromARGB(255, 28, 28, 28),
      input: Color.fromARGB(255, 40, 40, 40),
      ring: Color.fromARGB(255, 19, 68, 184),
    );
  }
}
