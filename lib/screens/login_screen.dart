import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'stations_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter your email')),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
                //Do something with the user input.
              },
              decoration: KTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            Roundedbutton(
              title: 'Log in',
              colour: Colors.orange,
              onPressed: () async {
                try {
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, StationsScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            Roundedbutton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Registeration',
              colour: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
