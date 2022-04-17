import 'package:flutter/material.dart';
 
class AppTheme {
  AppTheme._();
 
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold
      ) ,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black,
      primaryContainer: Colors.white38,
      secondary: Colors.black,
      onSecondary: Colors.white
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: Typography.blackMountainView,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
        textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black))
      )
    ),
    cardColor: Colors.white
  );
 
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold
      ) ,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.black,
      onPrimary: Colors.white,
      primaryContainer: Colors.black38,
      secondary: Colors.white,
      onSecondary: Colors.black
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: Typography.whiteMountainView,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))
      )
    ),
    cardColor: Colors.black
  );
}