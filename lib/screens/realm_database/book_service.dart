import 'package:library_manager_app/screens/realm_database/book.dart';
import 'package:realm/realm.dart';

class BookService {
  late final Realm realm;

  BookService() {
    final config = Configuration.local([Book.schema]);
    realm = Realm(config);
  }
  void addBook(String title, String author, int progress, double rating) {
    realm.write(
      () {
        realm.add(Book(ObjectId().toString(), title, author, progress, rating));
      },
    );
  }

  List<Book> getAllBooks() {
    return realm.all<Book>().toList();
  }

  void updateBook(Book updatedBook) {
    realm.write(() {
      realm.add(updatedBook, update: true);
    });
  }

  void deleteBook(String id) {
    final book = realm.find<Book>(id);
    if (book != null) {
      realm.write(() => realm.delete(book));
    }
  }
}
