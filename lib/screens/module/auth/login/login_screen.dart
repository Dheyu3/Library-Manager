import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_assets.dart';
import 'package:library_manager_app/misc/apps_style/app_colors.dart';
import 'package:library_manager_app/misc/apps_style/app_style.dart';
import 'package:library_manager_app/misc/apps_style/app_text.dart';
import 'package:library_manager_app/screens/module/auth/login/login_ctrl.dart';
import 'package:library_manager_app/screens/module/auth/signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginCtrl ctrl = Get.put(LoginCtrl());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Image(
                      image: AssetImage(AppAssets.loginScreen),
                    ),
                  ),
                  const Text(
                    AppText.login,
                    style:
                        TextStyle(fontSize: 33, color: AppColor.appBlueColor),
                  ),
                  const Text(
                    AppText.signToContinue,
                    style:
                        TextStyle(fontSize: 16, color: AppColor.appBlueColor),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    focusNode: emailFocus,
                    controller: ctrl.email,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordFocus);
                    },
                    validator: ctrl.validateEmail,
                    decoration: const InputDecoration(
                      labelText: AppText.email,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => TextFormField(
                      focusNode: passwordFocus,
                      controller: ctrl.password,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.phone,
                      obscureText: !ctrl.isPasswordVisible.value,
                      maxLength: 8,
                      validator: ctrl.validatePassword,
                      decoration: InputDecoration(
                        labelText: AppText.password,
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            ctrl.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            ctrl.isPasswordVisible.value =
                                !ctrl.isPasswordVisible.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          ctrl.login();
                        } else {
                          Get.snackbar(AppStyle.error, AppStyle.fixFormError,
                              backgroundColor: AppColor.errorColor,
                              colorText: AppColor.whiteColor);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.appBlueColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            AppText.loginIn,
                            style: TextStyle(
                                fontSize: 18, color: AppColor.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppText.notAccountMsg,
                        style: const TextStyle(color: AppColor.blackColor),
                        children: [
                          TextSpan(
                            text: AppText.createAccount,
                            style: const TextStyle(
                              color: AppColor.lightBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const SignupScreen());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
