import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_colors.dart';
import 'package:library_manager_app/screens/module/home/home_screen.dart';

class LoginCtrl extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  clear() {
    email.clear();
    password.clear();
  }

  Future<void> login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);
      if (userCredential.user != null) {
        Get.offAll(() => const HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'Unknown error',
          backgroundColor: AppColor.errorColor, colorText: AppColor.whiteColor);
    }
    clear();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    } else if (!value.trim().endsWith('@gmail.com')) {
      return "Email must be a Gmail address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }
}
