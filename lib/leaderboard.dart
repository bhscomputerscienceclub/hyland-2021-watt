import 'package:flutter/material.dart';
import 'package:hyland_2021_watt/data.dart';
import 'package:hyland_2021_watt/db/db.dart';
import 'package:tuple/tuple.dart';
import 'db/database.dart';
import 'listpage.dart';
import 'package:fl_chart/fl_chart.dart';
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
    print("initing");
    var l = await dataHandler.remote.getLeaderboard();
    print(l);
    setState(() {
      leaderboard = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget w = Text("Loading");
    if (leaderboard != null) {
      w = chart();
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

  Widget chart() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
            width: double.infinity,
            height: 300,
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BarChart(BarChartData(
                      barTouchData: BarTouchData(
                        enabled: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 16,
                          getTitles: (double value) {
                            return leaderboard![value.toInt()].item1;
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: mapIndexed(
                        leaderboard!,
                        (n, v) => makeGroupData(
                            n, (v as Tuple2<String, int>).item2.toDouble()),
                      ).toList(),
                    ))))));
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [Colors.cyan],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
