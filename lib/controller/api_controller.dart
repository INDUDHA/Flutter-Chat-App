import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../model/api.dart';

class ApiService {
  static const int _pageSize = 46;
  int _page = 1;

  Future<List<UserApi>?> getUsers() async {
    try {
      var url = Uri.parse('https://api.github.com/users?page=$_page&per_page=$_pageSize');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<UserApi> _model = jsonResponse.map((data) => UserApi(data['login'])).toList();
        // log(response.body);
        log(_page.toString());
        _page++;
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
