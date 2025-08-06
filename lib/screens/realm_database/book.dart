import 'package:realm/realm.dart';

part 'book.realm.dart';

@RealmModel()
class _Book {
  @PrimaryKey()
  late String id;
  late String title;
  late String author;
  late int progress;
  late double rating;
}
