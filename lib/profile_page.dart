

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';

import 'package:http/http.dart' as http;

import 'SizeConfig.dart';

Future<String> _getUserDetails() async {
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

class ProfilePage extends StatefulWidget {
  static String tag = 'profile-page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String userInfo;
  int _followingNo;
  int _followersNo;

  @override
  void initState() {
    final httpResponse = _getUserDetails();
    try {
      httpResponse.then((res) {
        var parsedJson = jsonDecode(res);
        var followingList = parsedJson['following'];
        var followersList = parsedJson['following'];
        setState(() {
          _followingNo = followingList.length;
          _followersNo = followersList.length;
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final hero = Hero(
        tag: 'hero',
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 72.0,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/ovidiu.jpg'),
          ),
        )
    );

    final userData = Column(
      children: <Widget>[
        Text(
            "Your username",
            style: TextStyle(
              color: Colors.white,
              fontSize: 3.0 * SizeConfig.textMultiplier,
              fontWeight: FontWeight.bold
            )
        ),
        SizedBox(height: 1.0 * SizeConfig.heightMultiplier),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                    "Followers",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                Text(
                  "${_followersNo}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.0 * SizeConfig.textMultiplier
                  )
                )
              ],
            ),
            SizedBox(width: 5.0 * SizeConfig.heightMultiplier),
            Column(
              children: <Widget>[
                Text(
                    "Following",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
                Text(
                    "${_followingNo}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.0 * SizeConfig.textMultiplier
                    )
                )
              ],
            ),
          ],
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: ListView(
        shrinkWrap: true,
        children: <Widget> [
          Row(
            children: <Widget>[
              hero,
              SizedBox(width: 5.0 * SizeConfig.widthMultiplier),
              userData
            ],
          )
        ]
      )
    );
  }

}