import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:tuple/tuple.dart';

class Remote {
  late Map<String, String> headers;
  String baseurl;
  //baseurl will not contain slash !!!!!
  Remote(String username, String password, this.baseurl) {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': basicAuth
    };
    _get('/login');
  }

  Future<Map<String, dynamic>> _get(String uri) async {
    var resp = await http.get(Uri.parse(baseurl + uri), headers: headers);
    print(resp.body);

    return json.decode(resp.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _post(
      String uri, Map<String, dynamic> data) async {
    var resp = await http.post(Uri.parse(baseurl + uri),
        headers: headers, body: json.encode(data));

    try {
      return json.decode(resp.body) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  createList(int len, int id) {
    _post("/users/shoppinglists", {
      "numItems": len,
      "listId": id,
    });
  }

  createItem(int listID, int id, String barcode) {
    _post("/users/shoppinglists/$listID/items", {
      'barcode': barcode,
      'itemId': id,
    });
  }

  Future<List<Tuple2<String, int>>> getLeaderboard() async {
    var resp =
        await http.get(Uri.parse(baseurl + '/leaderboard'), headers: headers);
    print(resp.body);
    var stuff = json.decode(resp.body) as List<dynamic>;
    var stuff2 = stuff.cast<List<dynamic>>().cast<Tuple2<String, int>>();
    return stuff2;
  }
}
