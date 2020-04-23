
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';

import 'package:http/http.dart' as http;

Future<String> getUserDetails() async {
  var token = await storage.read(key: 'jwt');
  var res = await http.get(
    "$SERVER_IP/me",
    headers: {
      "token": token
    }
  );
  print(res.body);
  if (res.statusCode == 200) return res.body;
  return null;
}

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {

    var res = getUserDetails();
    res.then((tag) {
      print("HAHA");
      print(tag);
    });

    final ovidiu = Hero(
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

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome Ovidiu',
        style: TextStyle(fontSize: 28.0, color: Colors.white)
      )
    );

    final lorem = Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget cursus velit, a imperdiet enim. Nullam a neque nisl. Donec gravida congue augue ut feugiat. Aenean et iaculis risus. Ut at facilisis sapien, eget tempus diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Suspendisse fermentum arcu lorem, id congue elit vestibulum eget. Maecenas consectetur tristique mauris in consectetur. Quisque eget fringilla leo. Aliquam ut diam arcu.',
            style: TextStyle(fontSize: 16.0, color: Colors.white)
        )
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient:
          LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent])
      ),
      child: Column(children: <Widget>[
        ovidiu, welcome, lorem
      ],)
    );

    return Scaffold(
      body: body,
    );
  }
}