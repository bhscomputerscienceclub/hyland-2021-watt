import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final int id;

  final String name;

  Person(this.id, this.name);
}

@Entity()
class ShoppingList {
  @primaryKey
  final int id;

  final int? time;

  int get numAlreadyItems => 2;

  int get numTodoItems => 2;

  ShoppingList(this.id, this.time);
}

@dao
abstract class ShoppingListDao {
  @Query("SELECT * FROM ShoppingList")
  Future<List<ShoppingList?>> findAllLists();

  @insert
  Future<void> insertList(ShoppingList list);
}

@Entity(primaryKeys: ["listID", "id"])
class ShoppingListItem {
  final int listID;
  final int id;

  final String desc;

  int? barcode;
  int? time;

  ShoppingListItem(this.listID, this.id, this.desc);
}

@dao
abstract class ShoppingListItemDao {
  @Query('SELECT * FROM ShoppingListItem WHERE listID = :listID')
  Future<List<ShoppingListItem?>> findAllInList(int listID);

  Future<int> findCountInList(int listID) async =>
      (await findAllInList(1)).length;

  @insert
  Future<void> insertItem(ShoppingListItem item);

  @update
  Future<void> updateItem(ShoppingListItem item);
}
