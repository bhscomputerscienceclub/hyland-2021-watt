import 'package:floor/floor.dart';

@Entity(primaryKeys: ["id"])
class ShoppingList {
  final int id;

  final int? time;

  int count;
  int done;

  ShoppingList(this.id, this.time, {this.count = 0, this.done = 0});
}

@dao
abstract class ShoppingListDao {
  @Query("SELECT * FROM ShoppingList WHERE id = :id LIMIT 1")
  Future<List<ShoppingList?>> findListByID(int id);

  @Query("SELECT * FROM ShoppingList")
  Stream<List<ShoppingList?>> findAllLists();

  @update
  Future<int> updateList(ShoppingList list);

  @insert
  Future<int> ins(ShoppingList l);

  @delete
  Future<int> del(ShoppingList l);
}

@Entity(primaryKeys: [
  "listID",
  "id"
], foreignKeys: [
  ForeignKey(
    childColumns: ['listID'],
    parentColumns: ['id'],
    entity: ShoppingList,
    onDelete: ForeignKeyAction.cascade,
  ),
])
class ShoppingListItem {
  final int listID;
  final int id;

  final String desc;

  String? barcode;
  int time;

  ShoppingListItem(this.listID, this.id, this.desc,
      {this.barcode = null, this.time = 0});
}

@dao
abstract class ShoppingListItemDao {
  @Query('SELECT * FROM ShoppingListItem WHERE listID = :listID')
  Future<List<ShoppingListItem?>> findAllInList(int listID);

  @Query('SELECT * FROM ShoppingListItem WHERE listID = :listID')
  Stream<List<ShoppingListItem>?> getItemsStreamByListID(int listID);

  Future<int> findCountInList(int listID) async =>
      (await findAllInList(listID)).length;

  Future<int> findCompletedInList(int listID) async {
    final list = await findAllInList(listID);
    list.remove((value) => value.barcode == null);
    return list.length;
  }

  @insert
  Future<int> insertItem(ShoppingListItem item);

  @update
  Future<int> updateItem(ShoppingListItem item);

  @delete
  Future<int> deleteItem(ShoppingListItem item);
}
