
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {

  final String id;
  final String username;
  final String text;

  const CommentCard({Key key, this.id, this.text, this.username}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: CircleAvatar(
//            radius: 20.0,
            backgroundImage: AssetImage('assets/ovidiu.jpg'),
          ),
          title: Text(widget.username),
          trailing: Icon(Icons.more_vert),
          subtitle: Text(widget.text),
        )
    );
  }
}