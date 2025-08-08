import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:library_manager_app/misc/apps_style/app_style.dart';
import 'package:library_manager_app/misc/apps_style/app_variable.dart';

class BookRepository {
  List<Map<String, dynamic>> allBooks = [];

  Future<void> addBookForCurrentUser(
      String title, String author, int progress) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(AppStyle.error, AppStyle.noLoginMsg);
      return;
    }

    final bookData = {
      AppVariable.userId: userId,
      AppVariable.title: title,
      AppVariable.author: author,
      AppVariable.progress: progress,
      AppVariable.timestamp: FieldValue.serverTimestamp(),
      AppVariable.averageRating: 0.0,
    };

    await FirebaseFirestore.instance
        .collection(AppVariable.books)
        .add(bookData);
  }

  Future<void> updateUserBook(
      String bookId, Map<String, dynamic> updatedData) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(AppStyle.error, AppStyle.noLoginMsg);
      return;
    }

    final bookDocRef =
        FirebaseFirestore.instance.collection(AppVariable.books).doc(bookId);
    final docSnapshot = await bookDocRef.get();

    if (!docSnapshot.exists) {
      Get.snackbar(AppStyle.error, AppStyle.bookNotExist);
      return;
    }

    updatedData[AppVariable.timestamp] = FieldValue.serverTimestamp();

    await bookDocRef.update(updatedData);
  }

  Future<void> deleteUserBook(String bookId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(AppStyle.error, AppStyle.noLoginMsg);
      return;
    }

    final bookDocRef =
        FirebaseFirestore.instance.collection(AppVariable.books).doc(bookId);
    final docSnapshot = await bookDocRef.get();

    if (!docSnapshot.exists) {
      Get.snackbar(AppStyle.error, AppStyle.bookNotExist);
      return;
    }

    await bookDocRef.delete();
    Get.snackbar(AppStyle.success, AppStyle.bookDeleteSuccessfully);
  }

  Future<void> getAllUsersBooks() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(AppVariable.books)
          .orderBy(AppVariable.timestamp, descending: true)
          .get();

      allBooks = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data[AppVariable.bookId] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      Get.snackbar(AppStyle.error, "$e");
    }
  }

  Future<void> addOrUpdateRating(String bookId, double rating) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(AppStyle.error, AppStyle.noLoginMsg);
      return;
    }

    final ratingsCollection =
        FirebaseFirestore.instance.collection(AppVariable.ratings);

    final querySnapshot = await ratingsCollection
        .where(AppVariable.bookId, isEqualTo: bookId)
        .where(AppVariable.userId, isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Update existing rating
      await ratingsCollection.doc(querySnapshot.docs.first.id).update({
        AppVariable.rating: rating,
        AppVariable.timestamp: FieldValue.serverTimestamp(),
      });
    } else {
      // Add new rating
      await ratingsCollection.add({
        AppVariable.bookId: bookId,
        AppVariable.userId: userId,
        AppVariable.rating: rating,
        AppVariable.timestamp: FieldValue.serverTimestamp(),
      });
    }

    await recalculateAndUpdateAverageRating(bookId);
  }

  Future<Map<String, dynamic>?> getBookById(String bookId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection(AppVariable.books)
          .doc(bookId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          data[AppVariable.bookId] = docSnapshot.id;
          return data;
        }
      }
      return null;
    } catch (e) {
      Get.snackbar(AppStyle.error, "$e");
      return null;
    }
  }

  Future<void> recalculateAndUpdateAverageRating(String bookId) async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection(AppVariable.ratings)
        .where(AppVariable.bookId, isEqualTo: bookId)
        .get();

    if (ratingsSnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance
          .collection(AppVariable.books)
          .doc(bookId)
          .update({
        AppVariable.rating: 0.0,
      });
      return;
    }

    final ratings = ratingsSnapshot.docs
        .map((doc) => (doc.data()[AppVariable.rating] as num).toDouble())
        .toList();

    final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

    await FirebaseFirestore.instance
        .collection(AppVariable.books)
        .doc(bookId)
        .update({
      AppVariable.rating: averageRating,
    });
  }
}
