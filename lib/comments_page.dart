
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/comment_card.dart';

import 'main.dart';
import 'models/post_model.dart';
import 'models/user_model.dart';

import 'package:http/http.dart' as http;

Future<void> httpPostComment(String postId, String text) async {
  final token = await storage.read(key: "jwt");
  final res = await http.post(
      "$SERVER_IP/post/comment/id=$postId",
      headers: {
        "token": token
      },
      body: {
        "text": text
      }
  );
}

class CommentsPage extends StatefulWidget {
  static String tag = 'comments-page';
  User user;
  Post post;

  CommentsPage(Object arguments) {
    Map<String, Object> map = arguments;
    user = map['user'];
    post = map['post'];
  }

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {

  TextEditingController _dialogController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insert new comment'),
            content: TextFormField(
              autofocus: true,
              controller: _dialogController,
            ),
            actions: <Widget>[
              RaisedButton(
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  _postComment();
                  Navigator.of(context).pop();
                },
                child: new Text("Post Comment"),
              )
            ],
          );

        }
    );
  }


  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: ListView.builder(
          itemCount: widget.post.comments.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> map = widget.post.comments[index];
            var id = map['id'];
            var username = widget.user.username;
            var text = map['text'];
            return CommentCard(id: id, username: username, text: text);
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_comment,
          color: Colors.white60,
        ),
        onPressed: () => _displayDialog(context)
      ),
    );
  }

  _postComment() {
    var text = _dialogController.text;
    var futureRes = httpPostComment(widget.post.id, text);

    futureRes.then((voidValue) {
      var futurePost = Post.getPost(widget.post.id);
      futurePost.then((onValue) {
        setState(() {
          widget.post = Post.fromJsonMap(jsonDecode(onValue));
        });
      });
    });
  }
}