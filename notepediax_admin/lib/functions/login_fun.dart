import 'package:course_admin/constants/const_variable.dart';
import 'package:course_admin/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LoginFunctions {
  static Future<void> loginAdmin(String email, String pass) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) async {
          // updating value in variables
          AdminDetails.adminEmail = value.user!.email;
          AdminDetails.adminUid = value.user!.uid;
          AdminDetails.isLogined = true;
          // updating value is local Database
          await Hive.box('cache').put('email', AdminDetails.adminEmail);
          await Hive.box('cache').put('uid', AdminDetails.adminUid);
          await Hive.box('cache').put('isLogined', AdminDetails.isLogined);
        })
        .then((value) => AdminDetails.adminEmail == 'admin@gmail.com'
            ? Get.offAll(() => const Home())
            : Get.snackbar('Error', 'You are not admin',
                colorText: Colors.white, backgroundColor: Colors.red))
        .onError((error, stackTrace) {
          Get.snackbar('Error', '$error',
              colorText: Colors.white, backgroundColor: Colors.red);
          return null;
        });

    //
  }
}
