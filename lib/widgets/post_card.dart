
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/comments_page.dart';
import 'package:flutterapp/models/post_model.dart';
import 'package:flutterapp/models/user_model.dart';

import '../main.dart';

String _getAgeFromTimeStamp(String timeStamp) {
  String ageString;
  Duration age = DateTime.parse(timeStamp)
                .difference(DateTime.now());

  if (age.inDays < -1)
    ageString = (-age.inDays).toString() + " days ago";
  else if (age.inDays == -1)
    ageString = "1 day ago";
  else if (age.inHours < -1)
    ageString = (-age.inHours).toString() + " hours ago";
  else if (age.inHours == -1)
    ageString = "1 hour ago";
  else if (age.inMinutes < -1)
    ageString = (-age.inMinutes).toString() + " minutes ago";
  else if (age.inSeconds == -1)
    ageString = "1 minute ago";
  else
    ageString = "Just now";

  return ageString;
}

class PostCard extends StatefulWidget {
  final User user;
  final Post post;

  const PostCard({Key key, this.user, this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6 / 4,
      child: Card(
        elevation: 2,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: <Widget>[
              _PostDetails(user: widget.user, post: widget.post,),
              Divider(color: Colors.grey),
              _PostText(text: widget.post.text),
              Divider(color: Colors.grey),
              _PostActions(user: widget.user, post: widget.post,)
            ],
          )
        )
      )
    );
  }
}

class _PostDetails extends StatefulWidget {
  final User user;
  final Post post;

  const _PostDetails({Key key, this.user, this.post}) : super(key: key);

  @override
  __PostDetailsState createState() => __PostDetailsState();
}

class __PostDetailsState extends State<_PostDetails> {
  @override
  Widget build(BuildContext context) {
    String _ageString = _getAgeFromTimeStamp(widget.post.createdAt);

    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          _UserImage(),
          SizedBox(width: 20.0,),
          _UserName(username: widget.user.username,),
          SizedBox(width: 20.0,),
          _PostAge(age: _ageString,)
        ],
      )
    );
  }
}

class _PostAge extends StatelessWidget {
  final String age;

  const _PostAge({Key key, this.age}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 4,
        child: Text(age)
    );
  }
}

class _UserImage extends StatelessWidget {
  const _UserImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/ovidiu.jpg')
      )
    );
  }
}

class _UserName extends StatelessWidget {
  final String username;

  const _UserName({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Text("ovidiuz"),
    );
  }

}

class _PostText extends StatelessWidget {
  final String text;
  const _PostText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(text)
      );
  }

}

class _PostActions extends StatefulWidget {

  final User user;
  final Post post;
  const _PostActions({Key key, this.post, this.user}) : super(key: key);

  @override
  __PostActionsState createState() => __PostActionsState();
}

class __PostActionsState extends State<_PostActions> {

  int likes;
  int comments;
  int shares;

  var likeColor;
  var shareColor;

  @override
  void initState() {
    likes = widget.post.likes;
    comments = widget.post.comments.length;
    shares = widget.post.shares;

    if (widget.post.likes_users.contains(widget.user.id)) {
      likeColor = Colors.blue;
    } else {
      likeColor = Colors.black26;
    }

    shareColor = Colors.black26;
  }

  _onLikePressed() {
    if (widget.post.likes_users.contains(widget.user.id)) {
      widget.post.likes_users.remove(widget.user.id);
      Post.unlikePost(widget.post.id);
      widget.post.likes--;
    } else {
      widget.post.likes_users.add(widget.user.id);
      Post.likePost(widget.post.id);
      widget.post.likes++;
    }

    setState(() {
      likes = widget.post.likes;

      if (widget.post.likes_users.contains(widget.user.id)) {
        likeColor = Colors.blue;
      } else {
        likeColor = Colors.black26;
      }
    });
  }

  _onCommentPressed() {
//    storage.write(key: 'user', value: jsonEncode(widget.user));
//    storage.write(key: 'post', value: jsonEncode(widget.post));
    Map<String, Object> map = new Map();
    map['user'] = widget.user;
    map['post'] = widget.post;
    Navigator.of(context).pushNamed(CommentsPage.tag, arguments: map);
  }

  _onSharePressed() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: likeColor,
                  onPressed: () {
                    _onLikePressed();
                  },
                ),
                Text(likes.toString())
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.insert_comment),
                  color: Colors.black26,
                  onPressed: () {
                    _onCommentPressed();
                  },
                ),
                Text(comments.toString())
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  color: shareColor,
                  onPressed: () {
                    _onSharePressed();
                  },
                ),
                Text(shares.toString())
              ],
            ),
          ),
        ],
      )
    );
  }
}
