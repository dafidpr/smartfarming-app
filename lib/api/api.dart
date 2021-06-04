import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://smartfarming.webmediadigital.com/api';
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;

    var postData = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    return postData;
  }

  sendPostData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    var postData = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
    return postData;
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();

    return await http.get(fullUrl, headers: _setHeaders());
  }

  getDataWithoutToken(apiURL) async {
    var fullUrl = _url + apiURL;
    return await http.get(fullUrl, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
