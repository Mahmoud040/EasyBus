import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reuseablecard.dart';
import 'package:flash_chat/components/cardcontent.dart';
import 'package:flash_chat/screens/Station1.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Station.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/Profile.dart';

class StationsScreen extends StatefulWidget {
  static const String id = 'stations_screen';
  final Customer cus;
  StationsScreen({this.cus});
  @override
  _StationsScreenState createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  var c = 0;
  int _selectedIndex = 0;
  var points;

  Future<List<Station>> getStations() async {
    List<Station> stations = List<Station>();

    FirebaseFirestore fs = FirebaseFirestore.instance;
    await fs.collection("Stations").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var numberOfBus = doc["numberOfBusses"];
        var stationNumber = doc["stationNumber"];
        var stationName = doc["stationName"];
        //print(stationName);
        Station st = new Station(
            numberOfBusses: numberOfBus,
            stationNumber: stationNumber,
            stationName: stationName);
        print(st.stationName);
        setState(() {});
        stations.add(st);
      });
    });
    c = stations.length;
    print(stations);
    return stations;
  }
  List<Station> _stat = List<Station>();

  _buildStations() {
    getStations().then((value) {
      _stat.addAll(value);
    });
    List<Widget> stationsList = [];
    for (var i = 0; i < c; i++) {
      stationsList.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    new Station1Screen(cus: widget.cus, sta: _stat[i]),
              ),
            );
          },
          child: Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[200],
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _stat[i].stationName,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          /*Text(
                            '${_stat[i].numberOfBusses} Busses ready',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),*/
                          SizedBox(height: 4.0),
                          Text(
                            '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Column(children: stationsList);
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();

    print(widget.cus.username);
  }
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: log out',
      style: optionStyle,
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index==0){
        Navigator.pushNamed(context, ProfileScreen.id);
      }
      else if (index==1){
        Navigator.popAndPushNamed(context, WelcomeScreen.id);
        _auth.signOut();

      }


    });
  }
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
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
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'log out',
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
        title: Text('⚡️Stations'),
        backgroundColor: Colors.orange,

      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildStations(),
            /* GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Station1Screen.id);
              },
              child: Expanded(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey[200],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Station 1',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '4 Busses ready',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '0.2 miles away',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Station2Screen.id);
              },
              child: Expanded(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey[200],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Station 2',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '4 Busses ready',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '0.2 miles away',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Station3Screen.id);
              },
              child: Expanded(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey[200],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Station 3',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '4 Busses ready',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '0.2 miles away',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Station4Screen.id);
              },
              child: Expanded(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey[200],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Station 4',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '4 Busses ready',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '0.2 miles away',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
