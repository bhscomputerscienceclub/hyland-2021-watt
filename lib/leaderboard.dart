import 'package:flutter/material.dart';
import 'package:hyland_2021_watt/data.dart';
import 'package:hyland_2021_watt/db/db.dart';
import 'package:tuple/tuple.dart';
import 'db/database.dart';
import 'listpage.dart';
import 'leaderboard.dart';

class MyLeaderboardPage extends StatefulWidget {
  const MyLeaderboardPage({Key? key}) : super(key: key);
  @override
  _MyLeaderboardState createState() => _MyLeaderboardState();
}

class _MyLeaderboardState extends State<MyLeaderboardPage> {
  List<Tuple2<String, int>>? leaderboard;
  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    var l = await dataHandler.remote.getLeaderboard();
    setState(() {
      leaderboard = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget w = Text("Loading");
    if (leaderboard != null) {
      w = ListView(
        padding: const EdgeInsets.all(8),
        children: leaderboard!
            .map(
              (v) => ListTile(title: Text(v.item1)),
            )
            .toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Highest Scores"),
      ),
      body: Center(
        child: w,
      ),
    );
  }
}
