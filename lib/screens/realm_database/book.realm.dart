// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Book extends _Book with RealmEntity, RealmObjectBase, RealmObject {
  Book(
    String id,
    String title,
    String author,
    int progress,
    double rating,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'author', author);
    RealmObjectBase.set(this, 'progress', progress);
    RealmObjectBase.set(this, 'rating', rating);
  }

  Book._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get author => RealmObjectBase.get<String>(this, 'author') as String;
  @override
  set author(String value) => RealmObjectBase.set(this, 'author', value);

  @override
  int get progress => RealmObjectBase.get<int>(this, 'progress') as int;
  @override
  set progress(int value) => RealmObjectBase.set(this, 'progress', value);

  @override
  double get rating => RealmObjectBase.get<double>(this, 'rating') as double;
  @override
  set rating(double value) => RealmObjectBase.set(this, 'rating', value);

  @override
  Stream<RealmObjectChanges<Book>> get changes =>
      RealmObjectBase.getChanges<Book>(this);

  @override
  Stream<RealmObjectChanges<Book>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Book>(this, keyPaths);

  @override
  Book freeze() => RealmObjectBase.freezeObject<Book>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'author': author.toEJson(),
      'progress': progress.toEJson(),
      'rating': rating.toEJson(),
    };
  }

  static EJsonValue _toEJson(Book value) => value.toEJson();
  static Book _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'author': EJsonValue author,
        'progress': EJsonValue progress,
        'rating': EJsonValue rating,
      } =>
        Book(
          fromEJson(id),
          fromEJson(title),
          fromEJson(author),
          fromEJson(progress),
          fromEJson(rating),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Book._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Book, 'Book', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('author', RealmPropertyType.string),
      SchemaProperty('progress', RealmPropertyType.int),
      SchemaProperty('rating', RealmPropertyType.double),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
