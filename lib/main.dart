
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterapp/comments_page.dart';
import 'package:flutterapp/home_page.dart';
import 'package:flutterapp/login_page.dart';
import 'package:flutterapp/news_feed.dart';
import 'package:flutterapp/profile_page.dart';
import 'package:flutterapp/signup_page.dart';
import 'package:flutterapp/widgets/post_card.dart';

import 'package:http/http.dart' as http;

import 'SizeConfig.dart';


const SERVER_IP = 'http://10.0.2.2:4000/user';

var storage = FlutterSecureStorage();

Future<String> attemptLogIn(String email, String password) async {
  var res = await http.post(
      "$SERVER_IP/login",
      body: {
        "email": email,
        "password": password
      }
  );
  print(res.statusCode);
  if(res.statusCode == 200) return res.body;
  return null;
}

Future<String> attemptSignUp(String username, String email, String password) async {
  var res = await http.post(
      "$SERVER_IP/signup",
      body: {
        "username": username,
        "email": email,
        "password": password
      }
  );
  if(res.statusCode == 200) return res.body;
  return null;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    SignUpPage.tag: (context) => SignUpPage(),
    ProfilePage.tag: (context) => ProfilePage(),
    NewsFeed.tag: (context) => NewsFeed(),
    CommentsPage.tag: (context) => CommentsPage(ModalRoute.of(context).settings.arguments)
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
                title: 'Startup Name Generator',
//      theme: ThemeData(
//        primaryColor: Colors.white,
//      ),
//      home: RandomWords(),
                theme: ThemeData(
                    primarySwatch: Colors.lightBlue,
                    fontFamily: 'Nunito'
                ),
                home: LoginPage(),
                routes: routes
            );
          },
        );
      },
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Startup Name Generator',
////      theme: ThemeData(
////        primaryColor: Colors.white,
////      ),
////      home: RandomWords(),
//      theme: ThemeData(
//        primarySwatch: Colors.lightBlue,
//        fontFamily: 'Nunito'
//      ),
//      home: LoginPage(),
//      routes: routes
//    );
//  }
}

class RandomWordsState extends State<RandomWords> {
  final Set<WordPair> _saved = Set<WordPair>();
  final List<WordPair> _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              }
          );
          final List<Widget> divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles
            ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions')
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

