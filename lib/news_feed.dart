
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/widgets/post_card.dart';

import 'package:http/http.dart' as http;

import 'models/post_model.dart';
import 'models/user_model.dart';

Future<String> _httpGETNewsFeed() async {
  final token = await storage.read(key: "jwt");
  final res = await http.get(
    "$SERVER_IP/newsfeed",
    headers: {
      "token": token
    }
  );
//  print(res.body);
  if (res.statusCode == 200) return res.body;
  return null;
}

Future<List<Post>> _getNewsfeed() async {
  final response = await _httpGETNewsFeed();
  final map = jsonDecode(response);
  final postsJson = map['posts'];
  final List<Post> posts = new List();
  for (var postJson in postsJson) {
    var post = Post.fromJsonMap(postJson);
    posts.add(post);
  }

  return posts;
}

class NewsFeed extends StatefulWidget {
  static String tag = 'news-feed';

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

  User _user;
  List<Post> _postsList;
  int _posts_count = 0;

  @override
  void initState() {

    if (_user != null && _postsList != null) {
      return;
    }

    final posts = _getNewsfeed();
    final userDetails = User.getUserDetails();
    try {
      posts.then((posts) {
        userDetails.then((details) {
          setState(() {
            var userMap = jsonDecode(details);
            _user = User.fromJsonMap(userMap);
            _postsList = posts;
            _posts_count = posts.length;
            print(_user);
            print(_postsList);
            print("HAAHHA");
          });
        });
      });
    } catch (err) {
      print(err.toString());
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("NXT"),
      ),
      body: ListView.builder(
        itemCount: _posts_count,
        itemBuilder: (BuildContext context, int index) {
          return PostCard(user: _user, post: _postsList[index],);
        },
      )
    );
  }
}