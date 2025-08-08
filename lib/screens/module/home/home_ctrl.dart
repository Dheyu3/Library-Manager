import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_variable.dart';
import 'package:library_manager_app/repository/book_repository.dart';

class HomeCtrl extends GetxController {
  final BookRepository _bookRepository = BookRepository();
  var username = "".obs;
  var isLoading = false.obs;
  var averageRating = 0.0.obs;

  Future<void> addOrUpdateRating(String bookId, double rating) async {
    try {
      isLoading.value = true;
      await _bookRepository.addOrUpdateRating(bookId, rating);
      await fetchAverageRating(bookId);
      Get.snackbar("Success", "Rating saved successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update rating: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAverageRating(String bookId) async {
    try {
      final bookData = await _bookRepository.getBookById(bookId);
      if (bookData != null && bookData.containsKey(AppVariable.averageRating)) {
        averageRating.value =
            (bookData[AppVariable.averageRating] as num).toDouble();
      } else {
        averageRating.value = 0.0;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch average rating: $e");
      averageRating.value = 0.0;
    }
  }

  Future<void> recalculateAverageRatingAndFetch(String bookId) async {
    try {
      isLoading.value = true;
      await _bookRepository.recalculateAndUpdateAverageRating(bookId);

      final latestBookData = await _bookRepository.getBookById(bookId);
      if (latestBookData != null &&
          latestBookData.containsKey(AppVariable.averageRating)) {
        averageRating.value =
            (latestBookData[AppVariable.averageRating] as num).toDouble();
      } else {
        averageRating.value = 0.0;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update average rating: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
