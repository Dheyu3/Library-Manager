import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_assets.dart';
import 'package:library_manager_app/misc/apps_style/app_colors.dart';
import 'package:library_manager_app/misc/apps_style/app_style.dart';
import 'package:library_manager_app/misc/apps_style/app_text.dart';
import 'package:library_manager_app/screens/module/book_add_edit/book_add_edit_ctrl.dart';

class BookAddEditScreen extends StatefulWidget {
  const BookAddEditScreen({super.key});

  @override
  State<BookAddEditScreen> createState() => _BookAddEditScreenState();
}

class _BookAddEditScreenState extends State<BookAddEditScreen> {
  final BookAddEditCtrl ctrl = Get.find<BookAddEditCtrl>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode authorFocus = FocusNode();
  final FocusNode titleFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_outlined),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        AppText.enterBookDetail,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor.whiteColor,
                        border: Border.all(color: AppColor.lightBlueColor),
                      ),
                      child: Image.asset(AppAssets.bookImage)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    focusNode: titleFocus,
                    controller: ctrl.title,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(authorFocus);
                    },
                    validator: ctrl.validateTitle,
                    decoration: const InputDecoration(
                      labelText: AppText.enterBookName,
                      prefixIcon: Icon(Icons.auto_stories_sharp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextFormField(
                    focusNode: authorFocus,
                    controller: ctrl.author,
                    validator: ctrl.validateAuthor,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: AppText.enterAuthorName,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    AppText.progressMsg,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Obx(
                  () => Slider(
                    value: ctrl.slider.value,
                    activeColor: AppColor.appBlueColor,
                    inactiveColor: AppColor.lightBlueColor,
                    label: ctrl.slider.value.round().toString(),
                    divisions: 100,
                    onChanged: (double value) {
                      ctrl.slider.value = value;
                    },
                    max: 100,
                    min: 0,
                    thumbColor: AppColor.lightGrayColor,
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "${AppText.readBookMsg}${ctrl.slider.value.toStringAsFixed(0)}${AppText.part}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(right: 12, left: 12, bottom: 20, top: 10),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final title = ctrl.title.text.trim();
                    final author = ctrl.author.text.trim();
                    final progress = ctrl.slider.value.toInt();
                    if (ctrl.selectedBookDocId.value.isEmpty) {
                      ctrl.addBook(title, author, progress);
                      Get.back();
                    } else {
                      await ctrl.updateBook();
                      ctrl.clear();
                      Get.back();
                    }
                    ctrl.clear();
                    Get.back();
                  } else {
                    Get.snackbar(AppStyle.error, AppStyle.fixFormError,
                        backgroundColor: AppColor.errorColor,
                        colorText: AppColor.whiteColor);
                  }
                },
                child: Text(
                  ctrl.selectedBookDocId.value.isEmpty
                      ? AppText.saveBook
                      : AppText.updateBook,
                  style:
                      const TextStyle(fontSize: 16, color: AppColor.whiteColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
