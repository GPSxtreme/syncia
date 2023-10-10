import 'package:flutter/material.dart';

final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        accentColor: Colors.blue),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(color: Colors.white),
      shape:
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: Colors.blue,
    )),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.blue),
      trackColor: MaterialStateProperty.all(Colors.white12),
      trackOutlineColor: MaterialStateProperty.all(Colors.black38),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    listTileTheme: const ListTileThemeData(
        iconColor: Colors.blue,
        subtitleTextStyle: TextStyle(
          color: Colors.white12,
        )));

final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
        accentColor: Colors.blue),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(color: Colors.white),
      shape:
          ContinuousRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      backgroundColor: Colors.blue,
    )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white12,
    ),
    listTileTheme: const ListTileThemeData(
        iconColor: Colors.blue,
        subtitleTextStyle: TextStyle(
          color: Colors.white12,
        )));
