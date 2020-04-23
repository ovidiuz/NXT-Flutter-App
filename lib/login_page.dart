import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapp/home_page.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/signup_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  @override
  Widget build(BuildContext buildContext) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo.png')
      )
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );

    final password = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)
          )
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        minWidth: 200.0,
        height: 45.0,
        onPressed: (){
          print("Hahaha");
          print(email.controller.text);
          print(email.initialValue);
          print(password.initialValue);
          print(password.controller.text);
          var status = attemptLogIn(email.controller.text, password.controller.text);
          print(status);
          status.then((response) {
            print(response);
            if (response != null) {
              var token = jsonDecode(response)['token'];
              storage.write(key: "jwt", value: token);
              Navigator.of(context).pushNamed(HomePage.tag);
            }
          });
        },
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final signUpLabel = FlatButton(
      child: Text("Don't have an account yet? Sign up", style: TextStyle(color: Colors.black54)),
      onPressed: () {
        Navigator.of(context).pushNamed(SignUpPage.tag);
      },
    );

    final forgotLabel = FlatButton(
      child: Text('Forgot password', style: TextStyle(color: Colors.black54)),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            loginButton,
            signUpLabel,
            forgotLabel
          ],
        )
      )
    );
  }
}