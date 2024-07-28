import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);


const KTextFieldDecoration =InputDecoration(
  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),

  hintText: '',

  contentPadding:
  EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.blueGrey, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepOrangeAccent, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),


);
const kLabelTextStyle =TextStyle(fontSize: 20.0,  fontWeight: FontWeight.bold,color: Colors.black);
const kBottomContainerHeight = 80.0;
const kBottomContainerColour = Color(0xFFEB1555);
const kActivecolour =Color(0xFF1C1C2D);
const kInactivecolour=Color(0xFF111328);
const kNumberText= TextStyle(fontSize: 50.0,fontWeight: FontWeight.w900,);

const kLabelDecoration =InputDecoration(
  hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),

  hintText: '',

  contentPadding:
  EdgeInsets.symmetric(vertical: 17.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),

  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white, width: 3),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.deepOrangeAccent, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),


);

