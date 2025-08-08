import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_assets.dart';
import 'package:library_manager_app/misc/apps_style/app_colors.dart';
import 'package:library_manager_app/misc/apps_style/app_text.dart';
import 'package:library_manager_app/misc/apps_style/app_variable.dart';
import 'package:library_manager_app/screens/module/book_add_edit/book_add_edit_ctrl.dart';
import 'package:library_manager_app/screens/module/book_add_edit/book_add_edit_screen.dart';
import 'package:library_manager_app/screens/module/profile/user_details_screen.dart';

import 'home_ctrl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookAddEditCtrl ctrl = Get.put(BookAddEditCtrl());

  @override
  void initState() {
    ctrl.getBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final User? user = FirebaseAuth.instance.currentUser;
    final HomeCtrl homeCtrl = Get.put(HomeCtrl());

    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: Obx(
            () {
              if (ctrl.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final filteredBooks = ctrl.filteredBooks;
              return Column(
                children: [
                  // if (user != null)
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const UserDetailsScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColor.lightGrayColor,
                            child: Image.asset(AppAssets.profileImage),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${AppText.welcome} ${user!.displayName?.capitalizeFirst}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: AppText.searchMsg,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // open the rating range dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => RatingRangeSliderDialog(
                                    initialMinRating:
                                        ctrl.minRatingFilter.value,
                                    initialMaxRating:
                                        ctrl.maxRatingFilter.value,
                                    onApply: (min, max) {
                                      ctrl.minRatingFilter.value = min;
                                      ctrl.maxRatingFilter.value = max;
                                      ctrl.applyFilters();
                                    },
                                    onClear: () {
                                      ctrl.minRatingFilter.value = 1.0;
                                      ctrl.maxRatingFilter.value = 5.0;
                                      ctrl.applyFilters();
                                    },
                                  ),
                                );
                              },
                              child: const Icon(Icons.tune_outlined),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: ctrl.filter,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  Expanded(
                    child: filteredBooks.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 280,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(250),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColor.blackColor,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  AppAssets.emptyImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                AppText.noBooksMsg,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.errorColor),
                              ),
                            ],
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: ctrl.filteredBooks.length,
                            itemBuilder: (context, index) {
                              final data = ctrl.filteredBooks[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColor.lightGrayColor,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: AppColor.appBlueColor
                                            .withOpacity(0.2),
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            data[AppVariable.title] ?? "",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        "${AppText.author} ${data[AppVariable.author] ?? ""}"),
                                    Text(
                                        "${AppText.progress} ${data[AppVariable.progress] ?? ""}"),
                                    Row(
                                      children: [
                                        Text(
                                          "${AppText.avgRating} ${_parseAverageRating(data[AppVariable.averageRating])}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 8),
                                        if (data[AppVariable.userId] ==
                                            currentUserId) ...[
                                          GestureDetector(
                                            onTap: () {
                                              ctrl.loadBookData(data);
                                              Get.to(const BookAddEditScreen());
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: AppColor.lightBlueColor,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              Get.dialog(DeleteDialog(
                                                onDelete: () {
                                                  ctrl.deleteBook(
                                                      data[AppVariable.bookId]);
                                                },
                                              ));
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: AppColor.errorColor,
                                            ),
                                          ),
                                        ] else ...[
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  double tempRating = (data[
                                                              AppVariable
                                                                  .rating] ??
                                                          0)
                                                      .toDouble();
                                                  return AlertDialog(
                                                    title: const Text(
                                                        AppText.updateRating),
                                                    content: StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                '${AppText.currentRating} ${tempRating.toStringAsFixed(1)}'),
                                                            const SizedBox(
                                                                height: 20),
                                                            RatingBar.builder(
                                                              initialRating:
                                                                  tempRating,
                                                              minRating: 0,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color: AppColor
                                                                    .appBlueColor,
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                setState(() {
                                                                  tempRating =
                                                                      rating;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Get.back(),
                                                        child: const Text(
                                                            AppText.cancel),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          try {
                                                            await homeCtrl
                                                                .addOrUpdateRating(
                                                                    data[AppVariable
                                                                        .bookId],
                                                                    tempRating);
                                                            await homeCtrl
                                                                .recalculateAverageRatingAndFetch(
                                                                    data[AppVariable
                                                                        .bookId]);
                                                            await ctrl
                                                                .getBook();
                                                          } catch (e) {
                                                            Get.snackbar(
                                                                "Error",
                                                                "Failed to update rating: $e");
                                                          }
                                                        },
                                                        child: const Text(
                                                            AppText.update),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Icon(
                                              Icons.star_rate,
                                              size: 20,
                                              color: AppColor.appBlueColor,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              heroTag: "Add&Edit",
              onPressed: () {
                ctrl.selectedBookDocId.value = "";
                ctrl.clear();
                Get.to(const BookAddEditScreen());
              },
              backgroundColor: AppColor.appBlueColor,
              child: const Icon(
                Icons.auto_stories_sharp,
                color: AppColor.whiteColor,
              ),
            ),
          )),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppText.delete),
      content: const Text(AppText.deleteMdg),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(AppText.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.errorColor,
          ),
          onPressed: () {
            onDelete();
            Get.back();
          },
          child: const Text(
            AppText.delete,
            style: TextStyle(color: AppColor.whiteColor),
          ),
        ),
      ],
    );
  }
}

class RatingRangeSliderDialog extends StatefulWidget {
  final double initialMinRating;
  final double initialMaxRating;
  final void Function(double, double) onApply;
  final VoidCallback onClear;

  const RatingRangeSliderDialog({
    Key? key,
    required this.initialMinRating,
    required this.initialMaxRating,
    required this.onApply,
    required this.onClear,
  }) : super(key: key);

  @override
  State<RatingRangeSliderDialog> createState() =>
      _RatingRangeSliderDialogState();
}

class _RatingRangeSliderDialogState extends State<RatingRangeSliderDialog> {
  late RangeValues tempRange;

  @override
  void initState() {
    super.initState();
    tempRange = RangeValues(widget.initialMinRating, widget.initialMaxRating);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppText.filterByRating),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Min: ${tempRange.start.toStringAsFixed(1)}'),
              const Spacer(),
              Text('Max: ${tempRange.end.toStringAsFixed(1)}'),
            ],
          ),
          RangeSlider(
            min: 0,
            max: 5,
            divisions: 5,
            labels: RangeLabels(
              tempRange.start.toStringAsFixed(1),
              tempRange.end.toStringAsFixed(1),
            ),
            values: tempRange,
            onChanged: (values) {
              setState(() {
                tempRange = values;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onClear();
            Navigator.of(context).pop();
          },
          child: const Text('Clear'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(tempRange.start, tempRange.end);
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

String _parseAverageRating(dynamic value) {
  if (value == null) return "0.0";
  if (value is double) return value.toStringAsFixed(1);
  if (value is int) return value.toDouble().toStringAsFixed(1);
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) return parsed.toStringAsFixed(1);
  }
  return "0.0";
}
