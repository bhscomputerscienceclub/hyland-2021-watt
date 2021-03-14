// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ShoppingListItemDao? _listItemsDaoInstance;

  ShoppingListDao? _listsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ShoppingListItem` (`listID` INTEGER NOT NULL, `id` INTEGER NOT NULL, `desc` TEXT NOT NULL, `barcode` TEXT, `time` INTEGER NOT NULL, FOREIGN KEY (`listID`) REFERENCES `ShoppingList` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, PRIMARY KEY (`listID`, `id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ShoppingList` (`id` INTEGER NOT NULL, `time` INTEGER, `count` INTEGER NOT NULL, `done` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ShoppingListItemDao get listItemsDao {
    return _listItemsDaoInstance ??=
        _$ShoppingListItemDao(database, changeListener);
  }

  @override
  ShoppingListDao get listsDao {
    return _listsDaoInstance ??= _$ShoppingListDao(database, changeListener);
  }
}

class _$ShoppingListItemDao extends ShoppingListItemDao {
  _$ShoppingListItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _shoppingListItemInsertionAdapter = InsertionAdapter(
            database,
            'ShoppingListItem',
            (ShoppingListItem item) => <String, Object?>{
                  'listID': item.listID,
                  'id': item.id,
                  'desc': item.desc,
                  'barcode': item.barcode,
                  'time': item.time
                },
            changeListener),
        _shoppingListItemUpdateAdapter = UpdateAdapter(
            database,
            'ShoppingListItem',
            ['listID', 'id'],
            (ShoppingListItem item) => <String, Object?>{
                  'listID': item.listID,
                  'id': item.id,
                  'desc': item.desc,
                  'barcode': item.barcode,
                  'time': item.time
                },
            changeListener),
        _shoppingListItemDeletionAdapter = DeletionAdapter(
            database,
            'ShoppingListItem',
            ['listID', 'id'],
            (ShoppingListItem item) => <String, Object?>{
                  'listID': item.listID,
                  'id': item.id,
                  'desc': item.desc,
                  'barcode': item.barcode,
                  'time': item.time
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ShoppingListItem> _shoppingListItemInsertionAdapter;

  final UpdateAdapter<ShoppingListItem> _shoppingListItemUpdateAdapter;

  final DeletionAdapter<ShoppingListItem> _shoppingListItemDeletionAdapter;

  @override
  Future<List<ShoppingListItem?>> findAllInList(int listID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ShoppingListItem WHERE listID = ?',
        arguments: [listID],
        mapper: (Map<String, Object?> row) => ShoppingListItem(
            row['listID'] as int, row['id'] as int, row['desc'] as String,
            barcode: row['barcode'] as String?, time: row['time'] as int));
  }

  @override
  Stream<List<ShoppingListItem>?> getItemsStreamByListID(int listID) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM ShoppingListItem WHERE listID = ?',
        arguments: [listID],
        queryableName: 'ShoppingListItem',
        isView: false,
        mapper: (Map<String, Object?> row) => ShoppingListItem(
            row['listID'] as int, row['id'] as int, row['desc'] as String,
            barcode: row['barcode'] as String?, time: row['time'] as int));
  }

  @override
  Future<int> insertItem(ShoppingListItem item) {
    return _shoppingListItemInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(ShoppingListItem item) {
    return _shoppingListItemUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteItem(ShoppingListItem item) {
    return _shoppingListItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}

class _$ShoppingListDao extends ShoppingListDao {
  _$ShoppingListDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _shoppingListInsertionAdapter = InsertionAdapter(
            database,
            'ShoppingList',
            (ShoppingList item) => <String, Object?>{
                  'id': item.id,
                  'time': item.time,
                  'count': item.count,
                  'done': item.done
                },
            changeListener),
        _shoppingListUpdateAdapter = UpdateAdapter(
            database,
            'ShoppingList',
            ['id'],
            (ShoppingList item) => <String, Object?>{
                  'id': item.id,
                  'time': item.time,
                  'count': item.count,
                  'done': item.done
                },
            changeListener),
        _shoppingListDeletionAdapter = DeletionAdapter(
            database,
            'ShoppingList',
            ['id'],
            (ShoppingList item) => <String, Object?>{
                  'id': item.id,
                  'time': item.time,
                  'count': item.count,
                  'done': item.done
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ShoppingList> _shoppingListInsertionAdapter;

  final UpdateAdapter<ShoppingList> _shoppingListUpdateAdapter;

  final DeletionAdapter<ShoppingList> _shoppingListDeletionAdapter;

  @override
  Future<List<ShoppingList?>> findListByID(int id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ShoppingList WHERE id = ? LIMIT 1',
        arguments: [id],
        mapper: (Map<String, Object?> row) => ShoppingList(
            row['id'] as int, row['time'] as int?,
            count: row['count'] as int, done: row['done'] as int));
  }

  @override
  Stream<List<ShoppingList?>> findAllLists() {
    return _queryAdapter.queryListStream('SELECT * FROM ShoppingList',
        queryableName: 'ShoppingList',
        isView: false,
        mapper: (Map<String, Object?> row) => ShoppingList(
            row['id'] as int, row['time'] as int?,
            count: row['count'] as int, done: row['done'] as int));
  }

  @override
  Future<int> ins(ShoppingList l) {
    return _shoppingListInsertionAdapter.insertAndReturnId(
        l, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateList(ShoppingList list) {
    return _shoppingListUpdateAdapter.updateAndReturnChangedRows(
        list, OnConflictStrategy.abort);
  }

  @override
  Future<int> del(ShoppingList l) {
    return _shoppingListDeletionAdapter.deleteAndReturnChangedRows(l);
  }
}
