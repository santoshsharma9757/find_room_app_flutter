import 'package:hive_flutter/hive_flutter.dart';

class AppUrl {
  static final primaryUrl = 'http://192.168.1.67:8000/';
  static final token = '';

  static final todoBox = Hive.box('AuthBox');

  storeToken(String token) {
    todoBox.put("token", token);
  }

  readToken() async {
    var token = await todoBox.get('token');
    return token;
  }

  storeUserId(String userId) {
    todoBox.put("userId", userId);
  }

  readUserId() async {
    var token = await todoBox.get('userId');
    return token;
  }
}
