import 'package:flutter/material.dart';
import 'package:syncia/styles/app_text.dart';
import 'package:syncia/styles/size_config.dart';

import 'app_colors.dart';

TextTheme createTextTheme(Color foreground) {
  return TextTheme(
    displayLarge: AppText.text7Xl.copyWith(color: foreground),
    displayMedium: AppText.text6Xl.copyWith(color: foreground),
    displaySmall: AppText.text5Xl.copyWith(color: foreground),
    headlineLarge: AppText.text4Xl.copyWith(color: foreground),
    headlineMedium: AppText.text3Xl.copyWith(color: foreground),
    headlineSmall: AppText.text2Xl.copyWith(color: foreground),
    titleLarge: AppText.textXl.copyWith(color: foreground),
    titleMedium: AppText.textLg.copyWith(color: foreground),
    titleSmall: AppText.textBase.copyWith(color: foreground),
    bodyLarge: AppText.textBase.copyWith(color: foreground),
    bodyMedium: AppText.textSm.copyWith(color: foreground),
    bodySmall: AppText.textXs.copyWith(color: foreground),
    labelLarge: AppText.textLg.copyWith(color: foreground),
    labelMedium: AppText.textBase.copyWith(color: foreground),
    labelSmall: AppText.textSm.copyWith(color: foreground),
  );
}

final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
        primary: AppColors.light().primary,
        onPrimary: AppColors.light().primaryForeground,
        secondary: AppColors.light().secondary,
        onSecondary: AppColors.light().secondaryForeground,
        error: AppColors.light().destructive,
        onError: AppColors.light().destructiveForeground,
        surface: AppColors.light().card,
        onSurface: AppColors.light().cardForeground,
        surfaceDim: AppColors.light().mutedForeground),
    textTheme: createTextTheme(AppColors.light().foreground),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light().muted,
      foregroundColor: AppColors.light().foreground,
      elevation: 0,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.light().muted,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.light().border,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: AppColors.light().primaryForeground),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)),
        backgroundColor: AppColors.light().primary,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.light().primary),
      trackColor:
          WidgetStateProperty.all(AppColors.light().primary.withOpacity(0.5)),
      trackOutlineColor: WidgetStateProperty.all(AppColors.light().border),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.light().primary,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.light().mutedForeground,
      subtitleTextStyle: TextStyle(
        color: AppColors.light().mutedForeground,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent, // Background color for the text field
      hintStyle:
          AppText.textBase.copyWith(color: AppColors.light().mutedForeground),
      border: OutlineInputBorder(
        // Normal state border
        borderRadius: AppBorderRadius.lg,
// Rounded corners
        borderSide: BorderSide(color: AppColors.light().border), // Border color
      ),
      enabledBorder: OutlineInputBorder(
        // Enabled state border
        borderRadius: AppBorderRadius.lg,

        borderSide: BorderSide(color: AppColors.light().border),
      ),
      focusedBorder: OutlineInputBorder(
        // Focused state border
        borderRadius: AppBorderRadius.lg,
        borderSide: BorderSide(
            color: AppColors.light().primary,
            width: 1.0), // Thicker border when focused
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12.0), // Padding inside the text field
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: AppBorderRadius.md,
            side: BorderSide(color: AppColors.light().border, width: 1.0))),
        side: WidgetStateProperty.all(
            BorderSide(color: AppColors.light().border, width: 1.0)),
        backgroundColor: WidgetStateProperty.all(AppColors.light().card),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxHeight: AppSpacing.xxl),
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.0, vertical: AppSpacing.sm),
        isCollapsed: true,
        border: OutlineInputBorder(
          // Adding a border
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.light().border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.light().border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.light().primary, width: 1.0),
        ),
      ),
    ));

final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        primary: AppColors.dark().primary,
        onPrimary: AppColors.dark().primaryForeground,
        secondary: AppColors.dark().secondary,
        onSecondary: AppColors.dark().secondaryForeground,
        error: AppColors.dark().destructive,
        onError: AppColors.dark().destructiveForeground,
        surface: AppColors.dark().card,
        onSurface: AppColors.dark().cardForeground,
        surfaceDim: AppColors.dark().mutedForeground),
    textTheme: createTextTheme(AppColors.dark().foreground),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark().muted,
      foregroundColor: AppColors.dark().foreground,
      elevation: 0,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.dark().muted,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.dark().border,
      space: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: AppColors.dark().primaryForeground),
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)),
        backgroundColor: AppColors.dark().primary,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.dark().primary),
      trackColor:
          WidgetStateProperty.all(AppColors.dark().primary.withOpacity(0.5)),
      trackOutlineColor: WidgetStateProperty.all(AppColors.dark().border),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.dark().primary,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: AppColors.dark().mutedForeground,
      subtitleTextStyle: TextStyle(
        color: AppColors.dark().mutedForeground,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent, // Background color for the text field
      hintStyle:
          AppText.textBase.copyWith(color: AppColors.dark().mutedForeground),
      border: OutlineInputBorder(
        // Normal state border
        borderRadius: AppBorderRadius.lg,
// Rounded corners
        borderSide: BorderSide(color: AppColors.dark().border), // Border color
      ),
      enabledBorder: OutlineInputBorder(
        // Enabled state border
        borderRadius: AppBorderRadius.lg,

        borderSide: BorderSide(color: AppColors.dark().border),
      ),
      focusedBorder: OutlineInputBorder(
        // Focused state border
        borderRadius: AppBorderRadius.lg,
        borderSide: BorderSide(
            color: AppColors.dark().primary,
            width: 1.0), // Thicker border when focused
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12.0), // Padding inside the text field
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: AppBorderRadius.md,
            side: BorderSide(color: AppColors.dark().border, width: 1.0))),
        side: WidgetStateProperty.all(
            BorderSide(color: AppColors.dark().border, width: 1.0)),
        backgroundColor: WidgetStateProperty.all(AppColors.dark().card),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0.0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxHeight: AppSpacing.xxl),
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.0, vertical: AppSpacing.sm),
        isCollapsed: true,
        border: OutlineInputBorder(
          // Adding a border
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.dark().border, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.dark().border, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.md,
          borderSide: BorderSide(color: AppColors.dark().primary, width: 1.0),
        ),
      ),
    ));
