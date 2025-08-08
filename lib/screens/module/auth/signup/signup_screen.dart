import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_assets.dart';
import 'package:library_manager_app/misc/apps_style/app_colors.dart';
import 'package:library_manager_app/misc/apps_style/app_style.dart';
import 'package:library_manager_app/misc/apps_style/app_text.dart';
import 'package:library_manager_app/screens/module/auth/signup/signup_ctrl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignupCtrl ctrl = Get.put(SignupCtrl());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode userFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () => ctrl.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Image(
                              image: AssetImage(AppAssets.signupScreen),
                            ),
                          ),
                          const Text(
                            AppText.signUp,
                            style: TextStyle(
                                fontSize: 33, color: AppColor.appBlueColor),
                          ),
                          const Text(
                            AppText.createAccountMsg,
                            style: TextStyle(
                                fontSize: 16, color: AppColor.appBlueColor),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            focusNode: userFocus,
                            validator: ctrl.validateUsername,
                            controller: ctrl.usernameCtrl,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(emailFocus);
                            },
                            decoration: const InputDecoration(
                              labelText: AppText.enterUserName,
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            focusNode: emailFocus,
                            controller: ctrl.emailCtrl,
                            validator: ctrl.validateEmail,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocus);
                            },
                            decoration: const InputDecoration(
                              labelText: AppText.email,
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => TextFormField(
                              focusNode: passwordFocus,
                              controller: ctrl.passwordCtrl,
                              validator: ctrl.validatePassword,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              keyboardType: TextInputType.number,
                              maxLength: 8,
                              obscureText: !ctrl.isPasswordVisible.value,
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
                                  ctrl.signUP();
                                } else {
                                  Get.snackbar(
                                      AppStyle.error, AppStyle.fixFormError,
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
                                    AppText.signUp,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColor.whiteColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
