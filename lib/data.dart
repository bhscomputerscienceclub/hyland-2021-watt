import 'package:hyland_2021_watt/db/database.dart';
import 'package:hyland_2021_watt/db/db.dart';

late _DataHandler dataHandler;

void create(AppDatabase a) {
  dataHandler = _DataHandler(a);
}

class _DataHandler {
  late ShoppingListDao _lists;
  late ShoppingListItemDao _items;

  _DataHandler(AppDatabase a) {
    _lists = a.listsDao;
    _items = a.listItemsDao;
  }

  Stream<List<ShoppingList>> get shoppingLists => (_lists.findAllLists())
      .where((v) => v != null)
      .map((v) => v.map((s) => s!).toList());

  Future<void> newList(ShoppingList ls) async {
    await _lists.ins(ls);
  }

  Future<void> deleteListByID(int id) async {
    final l = ShoppingList(id, null);
    await _lists.del(l);
  }

  Future<List<ShoppingListItem>> getItemsByListID(int id) async =>
      (await _items.findAllInList(id)).map((a) => a!).toList();
  Stream<List<ShoppingListItem>> getItemsStreamByListID(int id) =>
      (_items.getItemsStreamByListID(id))
          .where((v) => v != null)
          .map((v) => v!);

  Future<void> addItem(ShoppingListItem it) async {
    await _items.insertItem(it);
    var ls = await _lists.findListByID(it.listID);
    assert(ls.length > 0);
    ls[0]!.count++;
    await _lists.updateList(ls[0]!);
  }

  Future<void> deleteItemByID(int id, int listID) async {
    final l = ShoppingListItem(listID, id, "");
    await _items.deleteItem(l);
    var ls = await _lists.findListByID(listID);
    assert(ls.length > 0);
    ls[0]!.count--;
    _lists.updateList(ls[0]!);
  }

  Future<void> updateItemOnScan(ShoppingListItem it) async {
    var ls = await _lists.findListByID(it.listID);
    assert(ls.length > 0);
    ls[0]!.done++;
    _lists.updateList(ls[0]!);
    await _items.updateItem(it);
  }
}
