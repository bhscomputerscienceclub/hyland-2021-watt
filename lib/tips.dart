import 'package:flutter/material.dart';
import 'package:hyland_2021_watt/data.dart';
import 'package:hyland_2021_watt/db/db.dart';
import 'db/database.dart';
import 'listpage.dart';
import 'leaderboard.dart';
import 'tips.dart';

class Tips extends StatelessWidget {
  const Tips({Key? key}) : super(key: key);
  final List<String> items = const [
    "1. Organize your list by category, so that you can get items that are close together at the store at the same time.",
    "2. Shop at the same store every time - it’ll be much easier to find what you’re looking for once you get to know the layout of the store.",
    "3. Shop alone - while it is fun to go to the store with friends, you’ll be much less distracted and much more efficient if you go alone. This will leave you more time to hang out outside of the store!",
    "4. Find the sales before going into the store. It can be easy to get distracted by sales on items you want. If you plan ahead of time, you can figure out what you want and minimize that distraction.",
    "5. Avoid sunday nights. This is a super busy time for shoppers, and can slow you down when you’re trying to shop fast!"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Improve your score!"),
      ),
      body: Center(
          child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 3, color: Colors.grey),
              itemBuilder: (BuildContext context, int index) {
                // access element from list using index
                // you can create and return a widget of your choice
                return Center(
                    child: ListTile(title: Center(child: Text(items[index]))));
              })),
    );
  }
}
