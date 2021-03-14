import 'package:flutter/material.dart';
import 'package:hyland_2021_watt/data.dart';
import 'package:hyland_2021_watt/db/db.dart';
import 'db/database.dart';
import 'listpage.dart';
import 'leaderboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database1.db').build();
  create(database);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'home'),
        '/list': (context) => MyListPage(
            int.parse(ModalRoute.of(context)!.settings.arguments.toString())),
        '/leaderboard': (context) => MyLeaderboardPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ShoppingList> lists = [];

  void initState() {
    super.initState();
    listsSync();
  }

  void listsSync() async {
    await for (var ls in dataHandler.shoppingLists) {
      setState(() {
        lists = ls;
      });
    }
  }

  void addList() async {
    final ls = ShoppingList(DateTime.now().millisecondsSinceEpoch, null);
    await dataHandler.newList(ls);
  }

  void delList(int id) async {
    await dataHandler.deleteListByID(id);
  }

  void listTap(int id, BuildContext c) {}

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    var ongoingList = lists.toList();
    ongoingList.retainWhere((l) => (l.done < l.count && l.done != 0));
    var incompleteList = lists.toList();
    incompleteList.retainWhere((element) => element.done == 0);
    var completeList = lists.toList();
    completeList.retainWhere(
        (element) => element.done == element.count && element.count != 0);

    if (ongoingList.length > 0)
      tiles.add(Center(
          child: Text(
        "Ongoing Challenges",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      )));
    tiles += createListView(ongoingList);
    if (incompleteList.length > 0)
      tiles.add(Center(
          child: Text(
        "Not Started",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      )));
    tiles += createListView(incompleteList);
    if (completeList.length > 0)
      tiles.add(Center(
          child: Text(
        "Completed",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      )));
    tiles += createListView(completeList);

    if (tiles.length == 0)
      tiles.add(Center(
          child: Text(
        "Add new lists using the plus button",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: tiles,
      )),
      drawer: buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: addList,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buildDrawer(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'SuperShopper',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.bar_chart),
          title: Text('Leaderboard'),
          onTap: () => Navigator.pushNamed(
            context,
            '/leaderboard',
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
    ));
  }

  List<Widget> createListView(List<ShoppingList> lists) {
    return lists
        .map(
          (e) => Card(
              child: ListTile(
            title: Text("List ${e.id.toString()} - ${e.count} items"),
            trailing: IconButton(
                icon: Icon(Icons.delete), onPressed: () => delList(e.id)),
            onTap: () => Navigator.pushNamed(
              context,
              '/list',
              arguments: e.id,
            ),
          )),
        )
        .toList();
  }
}
