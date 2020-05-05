
import 'dart:convert';

import '../main.dart';
import 'package:http/http.dart' as http;


class User {

  final List<String> followers;
  final List<String> following;
  final List<String> postIds;
  final List<String> sharedPostIds;
  final String id;
  final String username;
  final String email;
  final String password;
  final int __v;

  User.fromJsonMap(Map<String, dynamic> map):
        followers = List<String>.from(map["followers"]),
        following = List<String>.from(map["following"]),
        postIds = List<String>.from(map["postIds"]),
        sharedPostIds = List<String>.from(map["sharedPostIds"]),
        id = map["_id"],
        username = map["username"],
        email = map["email"],
        password = map["password"],
        __v = map["__v"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followers'] = followers;
    data['following'] = following;
    data['postIds'] = postIds;
    data['sharedPostIds'] = sharedPostIds;
    data['_id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['__v'] = __v;
    return data;
  }

  static Future<String> getUserDetails() async {
    final token = await storage.read(key: 'jwt');
    final res = await http.get(
        "$SERVER_IP/me",
        headers: {
          "token": token
        }
    );
    print(res.body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  static Future<User> getCurrentUser() async {
    final userDetails = await getUserDetails();
    if (userDetails == null) {
      return null;
    }

    final userJson = jsonDecode(userDetails);
    final user = User.fromJsonMap(userJson);

    print(user);

    return user;
  }

}
