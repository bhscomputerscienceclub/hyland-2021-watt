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

  Future<List<ShoppingList>> get shoppingLists async =>
      (await _lists.findAllLists()).map((a) => a!).toList();
}
