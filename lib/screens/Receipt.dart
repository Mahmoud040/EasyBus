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

class ReceiptScreen extends StatefulWidget {
  static const String id = 'Receipt_screen';
  final Customer cus;
  final Station sta;
  final Bus bs;

  FirebaseFirestore fs = FirebaseFirestore.instance;

  ReceiptScreen({this.cus, this.sta, this.bs});

  @override
  ReceiptScreenState createState() => ReceiptScreenState();
}

class ReceiptScreenState extends State<ReceiptScreen> {
  var c = 0;
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;
  Duration duration= Duration(minutes: 1);
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
      const oneSecond = const Duration(seconds: 1);
      new Timer.periodic(oneSecond, (Timer t) => setState((){duration=duration-oneSecond;
      if (duration==Duration.zero) {
        String docid=widget.bs.busNumber.toString()+"_${reservations}";
        t.cancel();
        widget.fs
            .collection("buses")
            .doc(widget.bs.id)
            .update({'${reservations}': false})
            .then((value) => print("User Updated"))
            .catchError((error) =>
            print("Failed to update user: $error"));
        widget.fs.collection("reservations").doc(docid).delete();
        Customer cs=new Customer(uid: widget.cus.uid,username: widget.cus.username,email: widget.cus.email,password: widget.cus.password,points: widget.cus.points-5);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new SeatsScreen(
                cus: cs, bs: widget.bs, st: widget.sta),
          ),
        );


      }

      }));

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
    print(reservations);

    return reservations;
  }
  String timerString() {

    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
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
            labelText: 'bus number :${widget.bs.busNumber}',
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
            labelText: 'Seat number :${_Reser}',
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
            labelText: 'route:${widget.bs.route}',
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
            labelText: 'You Have ${timerString()} to Confirm',
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
        String docid = widget.bs.busNumber.toString() + "_${_Reser}";
        widget.fs
            .collection("buses")
            .doc(widget.bs.id)
            .update({'${_Reser}': false})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
        widget.fs.collection("reservations").doc(docid).delete();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => new SeatsScreen(
              cus: widget.cus,
              st: widget.sta,
              bs: widget.bs,
            ),
          ),
        );
      }
        else if(index==1){
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
              new Scanner(sta: widget.sta,bs: widget.bs,cus: widget.cus,),
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
            icon: Icon(Icons.cancel),
            label: 'cancel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QRCode',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
         Text(widget.cus.points.toString())
        ],
        title: Text('⚡️Receipt'),
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
