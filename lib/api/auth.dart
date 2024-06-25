import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  // String get _url => 'http://192.168.1.3:8000/api';
  final String _url = 'http://10.0.2.2:8000/api';

  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;
  var token1;
  var user;
  var id;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')?? "");
    token1 = localStorage.getString('token1') ?? '';
    user = jsonDecode(localStorage.getString('user') ?? '')['user'];
    id = jsonDecode(localStorage.getString('id') ?? '')['id'];
  }

  authData(data, apiUrl) async {
    print("aaaaaaaaaaaaaaaaaaabbbbbbbcccbbbbbbbbbbbbaaaaaaaaaaa");
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: await _setHeaders());
  }
  updateData(data, apiUrl) async {
    print("aaaaaaaaaaaaaaaaaaabbbbbbbcccbbbbbbbbbbbbaaaaaaaaaaa");
    var fullUrl = _url + apiUrl;
    return await http.put(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: await _setHeaders());
  }
   deleteData1(data, apiUrl) async {
    print("aaaaaaaaaaaaaaaaaaabbbbbbbcccbbbbbbbbbbbbaaaaaaaaaaa");
    var fullUrl = _url + apiUrl;
    print("aaaaaaaaaaaaaaaaaaabbbbbbbbbbccccbbbbbbbbbaaaaaaaaaaa");
    return await http.delete(Uri.parse(fullUrl),body: jsonEncode(data), headers: await _setHeaders());
  }

  getData(apiUrl) async {
    print("aaaaaaaaaaaaaaaaaaabbbbbbbcccbbbbbbbbbbbbaaaaaaaaaaa");
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: await _setHeaders());
  }
    deleteData(apiUrl) async {
    print("aaaaaaaaaaaaaaaaaaabbbbbbbcccbbbbbbbbbbbbaaaaaaaaaaa");
    var fullUrl = _url + apiUrl;
    return await http.delete(Uri.parse(fullUrl), headers: await _setHeaders());
  }
_setHeaders() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token2 = localStorage.getString('token') != null ? jsonDecode(localStorage.getString('token')!) : null;
  // print(token2);
  var headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': token2 != null ? 'Bearer $token2' : '',
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
  };
  return headers;
}}