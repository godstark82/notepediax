import 'package:flutter/material.dart';

class MyBottomSheetTheme {
  MyBottomSheetTheme._();

  static final lightBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: Colors.white,
    showDragHandle: true,
    modalBackgroundColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16)
    ),
  );

    static final darkBottomSheetTheme = BottomSheetThemeData(
    backgroundColor: Colors.black,
    showDragHandle: true,
    modalBackgroundColor: Colors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16)
    ),
  );
}