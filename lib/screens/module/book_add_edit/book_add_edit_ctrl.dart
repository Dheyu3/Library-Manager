import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/screens/realm_database/book.dart';
import 'package:library_manager_app/screens/realm_database/book_service.dart';

class BookAddEditCtrl extends GetxController {
  final title = TextEditingController();
  final author = TextEditingController();
  RxDouble slider = 0.0.obs;
  RxDouble rating = 2.0.obs;
  final BookService service = BookService();
  var books = <Book>[].obs;

  @override
  void onClose() {
    title.dispose();
    author.dispose();
    super.onClose();
  }

  void fetchBook() {
    books.value = service.getAllBooks();
  }

  void addBooks(String title, String author, int progress, double rating) {
    service.addBook(title, author, progress, rating);
    fetchBook();
    print("Book Added: $title, $author, $progress, $rating");
  }
}
