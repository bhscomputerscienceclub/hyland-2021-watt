import 'package:flutter/material.dart';
import 'package:hyland_2021_watt/data.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'db/db.dart';

class MyListPage extends StatefulWidget {
  MyListPage(this.id, {Key? key}) : super(key: key);

  final int id;
  @override
  _MyListPageState createState() => _MyListPageState(id);
}

class _MyListPageState extends State<MyListPage> {
  int count = 0;
  List<ShoppingListItem> items = [];

  _MyListPageState(this.id);
  final int id;
  final myController = TextEditingController();
  Stream<List<ShoppingListItem>>? s;

  @override
  initState() {
    super.initState();
    syncItems();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> l = [
      Expanded(
          child: ListView(
        padding: const EdgeInsets.all(8),
        children: items.length > 0
            ? createListView(items)
            : [Center(child: Text("No Items Yet"))],
      )),
    ];
    if (count == 0) l.add(fillOutThing());

    return Scaffold(
        appBar:
            AppBar(title: Text("List $id" + ((count > 0) ? " - Started" : ""))),
        body: Center(
            child: Column(
          children: l,
        )));
  }

  void syncItems() async {
    s = dataHandler.getItemsStreamByListID(id);
    await for (List<ShoppingListItem> ls in s!) {
      print(ls);
      print(ls.map((v) => v.barcode).toList());
      int c = ls.where((v) => v.barcode != null).length;
      setState(() {
        items = ls;
        count = c;
      });
    }
  }

  void addItem(String s) async {
    var item = ShoppingListItem(id, DateTime.now().millisecondsSinceEpoch, s);
    dataHandler.addItem(item);
  }

  void delItem(int id, int listID) async {
    await dataHandler.deleteItemByID(id, listID);
  }

  void scanItem(ShoppingListItem e) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    e.barcode = barcodeScanRes;
    e.time = DateTime.now().millisecondsSinceEpoch;
    print("Scanned barcode is $barcodeScanRes");
    dataHandler.updateItemOnScan(e);
  }

  List<Widget> createListView(List<ShoppingListItem> lists) {
    return lists.map((e) {
      List<Widget> buttons = [];
      if (count == 0) {
        buttons.addAll([
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => delItem(e.id, e.listID),
          ),
        ]);
      }
      if (e.barcode == null) {
        buttons.add(IconButton(
          icon: Icon(Icons.check),
          onPressed: () => scanItem(e),
        ));
      } else {
        buttons.addAll([
          Icon(
            Icons.check_box,
          )
        ]);
      }

      return Card(
          child: ListTile(
        title: Text(e.desc),
        trailing: Row(
          children: buttons,
          mainAxisSize: MainAxisSize.min,
        ),
      ));
    }).toList();
  }

  Widget fillOutThing() {
    return Form(
        key: UniqueKey(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )),
              TextButton(
                  onPressed: () {
                    addItem(myController.text);
                    myController.text = "";
                  },
                  child: Icon(Icons.send_outlined))
            ],
          ),
        ));
  }
}
