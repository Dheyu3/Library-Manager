import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_style.dart';
import 'package:library_manager_app/misc/apps_style/app_variable.dart';
import 'package:library_manager_app/repository/book_repository.dart';
import 'package:library_manager_app/screens/realm_database/book.dart';
import 'package:library_manager_app/screens/realm_database/book_service.dart';

class BookAddEditCtrl extends GetxController {
  final title = TextEditingController();
  final author = TextEditingController();
  RxDouble slider = 0.0.obs;
  RxDouble rating = 2.0.obs;
  final BookService service = BookService();
  var books = <Book>[].obs;
  RxString selectedBookDocId = ''.obs;
  var searchQuery = ''.obs;
  RxList<Map<String, dynamic>> allBooks = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredBooks = <Map<String, dynamic>>[].obs;
  RxString imageUrl = ''.obs;
  RxSet<int> selectedRatingsFilter = <int>{}.obs;
  RxBool isLoading = false.obs;
  RxDouble minRatingFilter = 0.0.obs;
  RxDouble maxRatingFilter = 5.0.obs;

  final BookRepository bookRepo = BookRepository();
  @override
  void onClose() {
    title.dispose();
    author.dispose();
    super.onClose();
  }

  clear() {
    title.clear();
    author.clear();
    slider.value = 0.0;
    rating.value = 2.0;
  }

  /*void fetchBook() {
    books.value = service.getAllBooks();
  }

  void addBooks(String title, String author, int progress, double rating) {
    service.addBook(title, author, progress, rating);
    fetchBook();
    clear();
    print("Book Added: $title, $author, $progress, $rating");
    print("Book Added to Firebase: $title, $author, $progress, $rating");
  }

  void editBook() {
    if (selectedBook.value != null) {
      final book = Book(
        selectedBook.value!.id,
        title.text,
        author.text,
        slider.value.toInt(),
        rating.value,
      );
      service.updateBook(book);
      fetchBook();
      clear();
      selectedBook.value = null;
      print("Book Updated: ${book.title}");
    }
  }

  void deleteBook(String id) {
    service.deleteBook(id);
    fetchBook();
  }*/

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return " Book Title required";
    }
    return null;
  }

  String? validateAuthor(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Author Name required";
    }
    return null;
  }

  // Add Book function
  Future<void> addBook(String title, String author, int progress) async {
    await bookRepo.addBookForCurrentUser(title, author, progress);
    await getBook();
  }

// get Books function
  Future<void> getBook() async {
    try {
      isLoading.value = true;
      await bookRepo.getAllUsersBooks();
      allBooks.assignAll(bookRepo.allBooks);
      applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRatingForOtherUserBook(
      String userId, String bookId, double newRating) async {
    try {
      await FirebaseFirestore.instance
          .collection(AppVariable.users)
          .doc(userId)
          .collection(AppVariable.books)
          .doc(bookId)
          .update({
        AppVariable.rating: newRating,
      });
      Get.back();
      await getBook();

      Get.snackbar(AppStyle.success, 'Rating updated successfully');
    } catch (e) {
      Get.snackbar(AppStyle.error, 'Failed to update rating: $e');
    }
  }

// update Function
  Future<void> updateBook() async {
    if (selectedBookDocId.value.isEmpty) {
      Get.snackbar(AppStyle.error, "No book selected to update");
      return;
    }

    Map<String, dynamic> updatedData = {
      AppVariable.title: title.text.trim(),
      AppVariable.author: author.text.trim(),
      AppVariable.progress: slider.value.toInt(),
      AppVariable.timestamp: FieldValue.serverTimestamp(),
    };

    try {
      await bookRepo.updateUserBook(selectedBookDocId.value, updatedData);
      await getBook();
      clear();
      selectedBookDocId.value = "";
      Get.back();
      Get.snackbar(AppStyle.success, "Book updated successfully");
    } catch (e) {
      Get.snackbar(AppStyle.error, "Failed to update book: $e");
    }
  }

  void loadBookData(Map<String, dynamic> bookData) {
    selectedBookDocId.value = bookData[AppVariable.bookId] ?? '';
    title.text = bookData[AppVariable.title] ?? '';
    author.text = bookData[AppVariable.author] ?? '';
    slider.value = (bookData[AppVariable.progress] ?? 0).toDouble();
    rating.value = (bookData[AppVariable.rating] ?? 0.0).toDouble();
  }

// delete function
  Future<void> deleteBook(String bookId) async {
    await bookRepo.deleteUserBook(bookId);
    await getBook();
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase().trim();
    final minRating = minRatingFilter.value;
    final maxRating = maxRatingFilter.value;

    final filtered = allBooks.where((book) {
      final title = (book[AppVariable.title] ?? '').toString().toLowerCase();
      final author = (book[AppVariable.author] ?? '').toString().toLowerCase();

      final avgRatingDouble = (book[AppVariable.averageRating] is num)
          ? (book[AppVariable.averageRating] as num).toDouble()
          : double.tryParse(
                  book[AppVariable.averageRating]?.toString() ?? '0.0') ??
              0.0;

      final matchesText = query.length < 3
          ? true
          : title.contains(query) || author.contains(query);

      final matchesRating =
          avgRatingDouble >= minRating && avgRatingDouble <= maxRating;

      return matchesText && matchesRating;
    }).toList();

    filteredBooks.assignAll(filtered);
  }

  void filter(String value) {
    searchQuery.value = value;
    applyFilters();
  }

  void setSelectedRatingsFilter(Set<int> selectedRatings) {
    selectedRatingsFilter.value = selectedRatings;
    applyFilters();
  }

  void clearRatingFilter() {
    selectedRatingsFilter.clear();
    applyFilters();
  }
}
