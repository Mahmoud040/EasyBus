import 'package:flash_chat/screens/driverSeats.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundedbutton.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Driver.dart';




class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool radioButtonstate = false;
  final _auth = FirebaseAuth.instance;
  final fieldText1 = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3= TextEditingController();
  final fieldText4 = TextEditingController();

  FirebaseFirestore fs = FirebaseFirestore.instance;
  String username;
  String email;
  String password;
  String confirmPassword;
  String busnumber;
  String stationNumber;
  String st='';
  void clearText() {
    fieldText1.clear();
    fieldText2.clear();
    fieldText3.clear();
    fieldText4.clear();
  }


  @override
  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF193044),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Edit your profile ',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                    fillColor: Color(0xFF193044),
                    contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {

                  username = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Username'),
                controller: fieldText3,
              ),
              TextField(

                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                KTextFieldDecoration.copyWith(hintText: 'Email'),
                controller: fieldText1,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {

                  password = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Password'),
                controller: fieldText2,

              ),

              SizedBox(
                height: 8.0,
              ),

              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Confirm your password'),
                controller: fieldText4,
              ),
              SizedBox(
                height: 8.0,
              ),

              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 8.0,
              ),

              SizedBox(height: 20.0),
              Roundedbutton(
                title: 'Cancel',
                colour: Colors.deepOrange,
                onPressed: ()  {
                  fieldText1.clear();
                  fieldText2.clear();
                  fieldText3.clear();
                  fieldText4.clear();


                },
              ),
              Roundedbutton(
                title: 'Save changes',
                colour: Colors.deepOrange,
                onPressed: () async {
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
