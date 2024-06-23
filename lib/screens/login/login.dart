import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      showPasswordVisibilityToggle: true,
      headerMaxExtent: 150,
      
      actions: [
        ForgotPasswordAction((context, email) {
          Get.toNamed('/forgot-password', arguments: {'email': email});
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          log('user signed in');
          if (FirebaseAuth.instance.currentUser!.metadata.lastSignInTime ==
              null) {
            log('This is a new User');
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .set({'name': 'Leader', 'info': 'new User Created'});
          }
          Get.toNamed('/home');
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          Get.toNamed('/home');
        }),
        VerifyPhoneAction((context, action) {
          Get.toNamed('/phone');
        }),
      ],
    );
  }
}
