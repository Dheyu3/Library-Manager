import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/screens/module/auth/login/login_screen.dart';

class SignupCtrl extends GetxController {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  var isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  clear() {
    emailCtrl.clear();
    passwordCtrl.clear();
    usernameCtrl.clear();
  }

  Future<void> signUP() async {
    isLoading.value = true;
    final userName = usernameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null && userName.isNotEmpty) {
      await userCredential.user!.updateDisplayName(userName);
      await userCredential.user!.reload();
    }

    isLoading.value = false;
    Get.offAll(() => const LoginScreen());
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required";
    }
    return null;
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
