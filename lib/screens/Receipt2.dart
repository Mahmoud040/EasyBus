import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reuseablecard.dart';
import 'package:flash_chat/components/cardcontent.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Station.dart';
import 'package:flash_chat/screens/scanner.dart';
import 'package:flash_chat/Bus.dart';
import 'welcome_screen.dart';

class Receipt2Screen extends StatefulWidget {
  static const String id = 'Receipt2_screen';
  final Customer cus;
  final Station sta;
  final Bus bs;

  FirebaseFirestore fs = FirebaseFirestore.instance;

  Receipt2Screen({this.cus, this.sta, this.bs});

  @override
  Receipt2ScreenState createState() => Receipt2ScreenState();
}

class Receipt2ScreenState extends State<Receipt2Screen> {
  var c = 0;
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;

  User loggedInUser;

  @override
  void initState() {
    super.initState();
    int reservations;
    widget.fs
        .collection("reservations")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        var RID = doc["UID"];
        setState(() {});
        if (busNumber == widget.bs.busNumber && RID == widget.cus.uid) {
          reservations = doc["seatnumber"];
          /* Map<int,String> res={
            doc["seatnumber"]:doc["UID"]

          };*/

          //reservations.addAll(res);
        }
      });
    });
    setState(() {

    });
    getCurrentUser();
  }

  Future<int> getReservations() async {
    int reservations;
    await widget.fs
        .collection("reservations")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        var RID = doc["UID"];
        setState(() {});
        if (busNumber == widget.bs.busNumber && RID == widget.cus.uid) {
          reservations = doc["seatnumber"];
          /* Map<int,String> res={
            doc["seatnumber"]:doc["UID"]

          };*/

          //reservations.addAll(res);
        }
      });
    });
    widget.fs
        .collection("Users")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var userPoints = doc["points"];

        setState(() {});

      });
    });
    print(reservations);

    return reservations;
  }


  int _Reser;


  _buildReservations() {
    getReservations().then((value) {
      // print(value);
      //print("im ass");
      //*setState(() {*//*
      _Reser = value;
      //* });*//*
    });
    List<Widget> reservations = [];
    reservations.add(
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Bus number: ${widget.bs.busNumber}',
            labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Color(0xFF193044),
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          ),
        ),
      ),
    );
    reservations.add(
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Seat number: ${_Reser}',
            labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
            filled: true,
            fillColor: Color(0xFF193044),
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          ),
        ),
      ),
    );
    reservations.add(
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Route: ${widget.bs.route}',
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




    );
    reservations.add(
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Confirmed!',
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




    );

    return ListView(children: reservations);
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: cancel',
      style: optionStyle,
    ),
    Text(
      'Index 1: QRCode',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => new StationsScreen(cus: widget.cus)),
        );
      }
      else if(index==1){
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new Scanner(),
          ),
        );
      }

    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_sharp),
            label: 'Stations',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                //SizedBox(height: 4.0),

                //SizedBox(height: 4.0),
                Icon(Icons.attach_money_sharp),

                Text(

                    '${widget.cus.points}',
                    style: kLabelTextStyle.copyWith(
                        color: Colors.white
                    )
                ),
              ],
            ),
          ),
        ],
        title: Text('⚡️Pick a seat!'),
        backgroundColor: Colors.orange,

      ),
      body: SafeArea(
        child: _buildReservations(),
      ),
      //_buildStations(),
      /*
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 1'),
                  ),
                ),
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 2'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 3'),
                  ),
                ),
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 4'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 5'),
                  ),
                ),
                Expanded(
                  child: reuseablecard(
                    gesture: () {
                      Navigator.pushNamed(context, SeatsScreen.id);
                    },
                    colour: Colors.white,
                    cardChild: contentcolnofunc(label: 'Bus 6'),
                  ),
                ),
              ],
            ),
          ],
          */
    );
  }
}
