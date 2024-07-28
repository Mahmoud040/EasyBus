import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/Profile.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reuseablecard.dart';
import 'package:flash_chat/components/cardcontent.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Station.dart';
import 'package:flash_chat/Bus.dart';
import 'package:flash_chat/screens/Receipt.dart';
import 'welcome_screen.dart';
import 'package:flash_chat/screens/Profile.dart';
import 'package:flash_chat/screens/Receipt2.dart';

class Station1Screen extends StatefulWidget {
  static const String id = '1';
  final Customer cus;
  final Station sta;


  Station1Screen({this.cus, this.sta});


  @override
  _Station1ScreenState createState() => _Station1ScreenState();
}

class _Station1ScreenState extends State<Station1Screen> {
  var c = 0;
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;

  User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }


  Future<List<Bus>> getBusses() async {
    List<Bus> Busses = List<Bus>();

    FirebaseFirestore fs = FirebaseFirestore.instance;
    await fs.collection("buses").get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        var id = doc.id;
        var route = doc["route"];
        var station = doc["station"];
        bool moving =doc["moving"];
        if (station == widget.sta.stationNumber && !moving) {
          Bus bs = new Bus(
              id: id,
              busNumber: busNumber,
              route: route,
              station: station);

          print(bs.busNumber);
          setState(() {});
          Busses.add(bs);
        }

        //print(stationName);
      });
    });
    c = Busses.length;
    print(Busses);
    return Busses;
  }

  List<Bus> _stat = List<Bus>();

  _buildStations() {
    getBusses().then((value) {
      // print(value);
      //print("im ass");
      //*setState(() {*//*
      _stat.addAll(value);
      //* });*//*
    });
    // _stat.addAll(getStations());
    List<Widget> BussesList = [];
    for (var i = 0; i < c; i++) {
      BussesList.add(
          GestureDetector(
              onTap: () async {
                FirebaseFirestore fs = FirebaseFirestore.instance;
                bool y = false;
                await fs
                    .collection("reservations")
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    var busNumber = doc["busNumber"];
                    var RID = doc["UID"];
                    if (busNumber == _stat[i].busNumber &&
                        RID == widget.cus.uid)
                      y = true;
                    setState(() {});
                  });
                });
                if (y) {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                      new Receipt2Screen(
                          cus: widget.cus, bs: _stat[i], sta: widget.sta),
                    ),
                  );
                  /* Map<int,String> res={
            doc["seatnumber"]:doc["UID"]

          };*/

                  //reservations.addAll(res);
                }
                else {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                      new SeatsScreen(
                          cus: widget.cus, bs: _stat[i], st: widget.sta),
                    ),
                  );
                }
              },
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
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
                                'Bus ${_stat[i].busNumber}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${_stat[i].route} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
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


              )



          )


      );
    }

  return ListView(children:BussesList);
}

static const TextStyle optionStyle =
TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
static const List<Widget> _widgetOptions = <Widget>[
  Text(
    'Index 0: Stations',
    style: optionStyle,
  ),
  Text(
    'Index 1: Profile',
    style: optionStyle,
  ),
];

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
            new StationsScreen(cus: widget.cus)
        ),
      );
    }
    else {
      Navigator.pushNamed(context, ProfileScreen.id);
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
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,


    ),
    appBar: AppBar(
      leading: null,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                  new StationsScreen(cus: widget.cus),
                ),
              );
              _auth.signOut();

              //Implement logout functionality
            }),
      ],
      title: Text('⚡️Station${widget.sta.stationNumber}'),
      backgroundColor: Colors.orange,
    ),
    body: SafeArea(
      child:
      _buildStations(),
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

    ),
  );
}}
