import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Pallete.blueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        )),
  );
}
