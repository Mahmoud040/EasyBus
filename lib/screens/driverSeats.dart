import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/reuseablecard.dart';
import 'package:flash_chat/components/cardcontent.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Driver.dart';
import 'package:flash_chat/Bus.dart';
import 'package:flash_chat/Station.dart';

class DriverSeatsScreen extends StatefulWidget {
  static const String id = 'dseats_screen';
  final Driver cus;
  final Bus bs;
  FirebaseFirestore fs = FirebaseFirestore.instance;

  DriverSeatsScreen({this.cus, this.bs});

  @override
  _DriverSeatsScreenState createState() => _DriverSeatsScreenState();
}

class _DriverSeatsScreenState extends State<DriverSeatsScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  int _selectedIndex = 0;
  List<bool> pressed = List.filled(50, false);

  Future<List<bool>> getSeats() async {
    List<bool> Seats = List<bool>();
    await widget.fs
        .collection("buses")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        if (busNumber == widget.cus.busNo) {
          for (int i = 1; i <= 50; i++) {
            setState(() {});
            Seats.add(doc[i.toString()]);
          //  print(doc[i.toString()]);
            setState(() {});
          }
        }
      });
    });
    return Seats;
  }
  Future<Map<int,String>> getReservations() async {
    Map<int,String> reservations=new Map<int,String>();
    await widget.fs
        .collection("reservations")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        if (busNumber == widget.bs.busNumber) {

          reservations.addEntries([MapEntry(doc["seatnumber"],doc["UID"])]);
          /* Map<int,String> res={
            doc["seatnumber"]:doc["UID"]

          };*/

          //reservations.addAll(res);
        }
      });
    });
   // print(reservations);


    return reservations;
  }
  List<bool> _stat = List<bool>();
  Map<int,String> _Reser = new Map<int,String>();

  _buildSeats() {
    getSeats().then((value) {
      _stat.addAll(value);
    });
    getReservations().then((value) {
      // print(value);
      //print("im ass");
      //*setState(() {*//*
      _Reser.addAll(value);
      //* });*//*
    });
    List<Widget> seatsList = [];
    setState(() {});
    seatsList.add(
      Row(
        children: [
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[0] == false) {
                    _stat[0] = true;
                    pressed[0] = true;

                    print('pressed');
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'1': _stat[0]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _stat[0] = false;
                    pressed[0] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'1': _stat[0]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                });
              },
              taken: _stat[0],
              cardChild: contentcolnofunc(label: '1'),
            ),
          ),
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[1] == false) {
                    _stat[1] = true;
                    pressed[1] = true;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'2': _stat[1]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                    print('pressed');
                  } else {
                    _stat[1] = false;
                    pressed[1] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'2': _stat[1]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                });
              },
              taken: _stat[1],
              cardChild: contentcolnofunc(label: '2'),
            ),
          ),
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[2] == false) {
                    _stat[2] = true;
                    pressed[2] = true;
                    print('pressed');
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'3': _stat[2]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _stat[2] = false;
                    pressed[2] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'3': _stat[2]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                });
              },
              taken: _stat[2],
              cardChild: contentcolnofunc(label: '3'),
            ),
          ),
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[3] == false) {
                    _stat[3] = true;
                    pressed[3] = true;
                    print('pressed');
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'4': _stat[3]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _stat[3] = false;
                    pressed[3] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'4': _stat[3]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                });
              },
              taken: _stat[3],
              cardChild: contentcolnofunc(label: '4'),
            ),
          ),
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[4] == false) {
                    _stat[4] = true;
                    pressed[4] = true;
                    print('pressed');
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'5': _stat[4]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _stat[4] = false;
                    pressed[4] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'5': _stat[4]})
                        .then((value) => print("User Updated"))
                        .catchError(
                          (error) => print("Failed to update user: $error"),
                        );
                  }
                });
              },
              taken: _stat[4],
              cardChild: contentcolnofunc(label: '5'),
            ),
          ),
        ],
      ),
    );
    for (var i = 5; i < 49; i = i + 4) {
      setState(() {});
      seatsList.add(
        Row(
          children: [
            Expanded(
              child: reuseablecard(
                gesture: () {
                  setState(() {
                    if (pressed[i] == false) {
                      _stat[i] = true;
                      pressed[i] = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 1}': _stat[i]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    } else {
                      _stat[i] = false;
                      pressed[i] = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 1}': _stat[i]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    }
                  });
                },
                taken: _stat[i],
                cardChild: contentcolnofunc(label: '${i + 1}'),
              ),
            ),
            Expanded(
              child: reuseablecard(
                gesture: () {
                  setState(() {
                    if (pressed[i + 1] == false) {
                      _stat[i + 1] = true;
                      pressed[i + 1] = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 2}': _stat[i + 1]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    } else {
                      _stat[i + 1] = false;
                      pressed[i + 1] = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 2}': _stat[i + 1]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    }
                  });
                },
                taken: _stat[i + 1],
                cardChild: contentcolnofunc(label: '${i + 2}'),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: reuseablecard(
                gesture: () {
                  setState(() {
                    if (pressed[i + 2] == false) {
                      _stat[i + 2] = true;
                      pressed[i + 2] = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 3}': _stat[i + 2]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    } else {
                      _stat[i + 2] = false;
                      pressed[i + 2] = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 3}': _stat[i + 2]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    }
                  });
                },
                taken: _stat[i + 2],
                cardChild: contentcolnofunc(label: '${i + 3}'),
              ),
            ),
            Expanded(
              child: reuseablecard(
                gesture: () {
                  setState(() {
                    if (pressed[i + 3] == false) {
                      _stat[i + 3] = true;
                      pressed[i + 3] = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 4}': _stat[i + 3]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    } else {
                      _stat[i + 3] = false;
                      pressed[i + 3] = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'${i + 4}': _stat[i + 3]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
                    }
                  });
                },
                taken: _stat[i + 3],
                cardChild: contentcolnofunc(label: '${i + 4}'),
              ),
            ),
          ],
        ),
      );
    }
    setState(() {});
    seatsList.add(
      Row(
        children: [
          Expanded(
            child: reuseablecard(
              gesture: () {
                setState(() {
                  if (pressed[49] == false) {
                    _stat[49] = true;
                    pressed[49] = true;
                    print('pressed');
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'50': _stat[49]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  } else {
                    _stat[49] = false;
                    pressed[49] = false;
                    widget.fs
                        .collection("buses")
                        .doc(widget.bs.id)
                        .update({'50': _stat[49]})
                        .then((value) => print("User Updated"))
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                  }
                });
              },
              taken: _stat[49],
              cardChild: contentcolnofunc(label: '50'),
            ),
          ),
          SizedBox(
            width: 300.0,
          ),
        ],
      ),
    );

    return ListView(children: seatsList);
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Stations',
      style: optionStyle,
    ),
    Text(
      'Index 1: QRCode',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
   // print(widget.cus.username);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //  print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 60, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptionss = <Widget>[
    Text(
      'Index 0: Drive',
      style: optionStyle,
    ),
    Text(
      'Index 1: empty',
      style: optionStyle,
    ),
    Text(
      'Index : ready',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(()   {

      _selectedIndex = index;

      if (index == 1) {
        for(int i=1;i<=50;i++){
          _stat[i-1]=false;
          String docid=widget.bs.busNumber.toString()+"_$i";
           widget.fs
              .collection("buses")
              .doc(widget.bs.id)
              .update({'$i': false})
              .then((value) => print("User Updated"))
              .catchError((error) =>
              print("Failed to update user: $error"));
          widget.fs.collection("reservations").doc(docid).delete();
        }

        }
      else if(index==0){
        var numberofBus;
        widget.fs
            .collection("buses")
            .doc(widget.bs.id)
            .update({'moving': true})
            .then((value) => print("User Updated"))
            .catchError((error) =>
            print("Failed to update user: $error"));
        widget.fs.collection("Stations").get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if(widget.bs.station==doc["stationNumber"])
              numberofBus = doc["numberOfBusses"];
            widget.fs
                .collection("Stations")
                .doc("station${doc["stationNumber"]}")
                .update({'numberOfBusses': numberofBus-1})
                .then((value) => print("User Updated"))
                .catchError((error) =>
                print("Failed to update user: $error"));

            setState(() {});
            //print(stationName);

            setState(() {});
          });
        });




      }
      else if (index==2){
        widget.fs
            .collection("buses")
            .doc(widget.bs.id)
            .update({'moving': false})
            .then((value) => print("User Updated"))
            .catchError((error) =>
            print("Failed to update user: $error"));
        int stNumber =0;
        int destnumber=0;



          widget.fs
            .collection("buses")
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            var busNumber = doc["busNumber"];
            if (busNumber == widget.bs.busNumber){
              stNumber=doc["station"];
              destnumber=doc["dest"];
              print(stNumber);
              print('----------------------------------------------------------------');
              int temp=stNumber;

              stNumber=destnumber;
              destnumber=temp;


              widget.fs
                  .collection("buses")
                  .doc(widget.bs.id)
                  .update({'station': stNumber,'dest':destnumber})
                  .then((value) => print("User Updated"))
                  .catchError((error) =>
                  print("Failed to update user: $error"));
              widget.fs.collection("Stations").get().then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  var numberofBus;
                  if(widget.bs.station==doc["stationNumber"])
                    numberofBus = doc["numberOfBusses"];
                  widget.fs
                      .collection("Stations")
                      .doc("station${stNumber}")
                      .update({'numberOfBusses': numberofBus+1})
                      .then((value) => print("User Updated"))
                      .catchError((error) =>
                      print("Failed to update user: $error"));

                  setState(() {});
                  //print(stationName);

                  setState(() {});
                });
              });




            }

            setState(() {});
          });
        });



      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_sharp),
            label: 'Drive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_remove_sharp),
            label: 'empty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking_sharp),
            label: 'park',
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
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
                _auth.signOut();
              }),
        ],
        title: Text('⚡️Pick a seat!'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: _buildSeats(),
      ),
    );
  }
}
