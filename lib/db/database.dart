// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'db.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [ShoppingListItem, ShoppingList])
abstract class AppDatabase extends FloorDatabase {
  ShoppingListItemDao get listItemsDao;
  ShoppingListDao get listsDao;
}
