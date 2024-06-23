import 'package:course_app/constants/styles/custom/appbar_theme.dart';
import 'package:course_app/constants/styles/custom/bottomsheet_theme.dart';
import 'package:course_app/constants/styles/custom/chip_theme.dart';
import 'package:course_app/constants/styles/custom/text_theme.dart';
import 'package:course_app/constants/styles/custom/textfield_theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyThemeData {
  MyThemeData._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: HexColor('f6f5f3'),
    primaryColor: Colors.blue,
    cardColor: Colors.white,
    textTheme: MyTextTheme.lightTextTheme,
    fontFamily: 'Naruto',
    // elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,
    chipTheme: MyChipTheme.lightChipTheme,
    inputDecorationTheme: MyTextFieldTheme.lightInputDecorationTheme,

    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Naruto',
    useMaterial3: true,
    cardColor: HexColor("222B32"),
    scaffoldBackgroundColor: Color.fromARGB(255, 8, 20, 28),
    textTheme: MyTextTheme.darkTextTheme,
    // elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: MyBottomSheetTheme.darkBottomSheetTheme,
    chipTheme: MyChipTheme.darkChipTheme,
    inputDecorationTheme: MyTextFieldTheme.darkInputDecorationTheme,
    primaryColor: Colors.blue,
    brightness: Brightness.dark,
  );
}
