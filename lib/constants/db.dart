import 'package:flutter/material.dart';

class DatabaseClass {
  static String? uid;
  static bool? isLogined;
}

ValueNotifier<Map<String, dynamic>> db = ValueNotifier({});
