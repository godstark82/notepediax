import 'package:course_admin/constants/const_variable.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

class InitFunctions {
  static Future<void> init() async {
    try {
      AdminDetails.adminEmail = await Hive.box('cache').get('email') ?? '';
      AdminDetails.adminUid = Hive.box('cache').get('uid') ?? '';
      AdminDetails.isLogined = Hive.box('cache').get('isLogined') ?? false;
    } catch (e) {
      debugPrint(e.toString());
    }

    //
  }
}
