import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/Station1.dart';
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
import 'package:flash_chat/screens/Receipt.dart';
import 'package:flash_chat/screens/Profile.dart';
class SeatsScreen extends StatefulWidget {
  static const String id = 'seats_screen';
  final Customer cus;
  final Bus bs;
  final Station st;
  FirebaseFirestore fs = FirebaseFirestore.instance;

  SeatsScreen({this.cus, this.bs, this.st});

  @override
  _SeatsScreenState createState() => _SeatsScreenState();
}

class _SeatsScreenState extends State<SeatsScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  int _selectedIndex = 0;

  List<bool> pressed = List.filled(50, false);
  bool _pressedseat = false;

  Future<List<bool>> getSeats() async {
    List<bool> Seats = List<bool>();

    await widget.fs
        .collection("buses")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var busNumber = doc["busNumber"];
        if (busNumber == widget.bs.busNumber) {
          for (int i = 1; i <= 50; i++) {
            setState(() {});
            Seats.add(doc[i.toString()]);
            print(doc[i.toString()]);
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

        }
      });
    });
    print(reservations);


    return reservations;
  }


  List<bool> _stat = List<bool>();
  Map<int,String> _Reser = new Map<int,String>();

  _buildSeats() {
    getSeats().then((value) {
      // print(value);
      //print("im ass");
      //*setState(() {*//*
      _stat.addAll(value);
      //* });*//*
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
                  if (_pressedseat == false) {
                    if (pressed[0] == false&&_stat[0]==false) {
                      _stat[0] = true;
                      pressed[0] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'1': _stat[0]})
                          .then((value) => print("User Updated"),)
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_1";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':1,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );


                    }
                  }
                  else {
                    String docid=widget.bs.busNumber.toString()+"_1";
                    print(_Reser[1]);
                    print('-----------------------------------------------------------------------------------------------');
                    if (pressed[0] == true&& _Reser[1]==widget.cus.uid) {
                      _stat[0] = false;
                      pressed[0] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'1': _stat[0]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();
                      setState(() {

                      });

                    }

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


                  if (_pressedseat == false) {
                    if (pressed[1] == false&&_stat[1]==false) {
                      _stat[1] = true;
                      pressed[1] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'2': _stat[1]})
                          .then((value) => print("User Updated"),)
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_2";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':2,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );


                    }
                  }
                  else {
                    String docid=widget.bs.busNumber.toString()+"_2";
                    print(_Reser[2]);
                    print('-----------------------------------------------------------------------------------------------');
                    if (pressed[1] == true&& _Reser[2]==widget.cus.uid) {
                      _stat[1] = false;
                      pressed[1] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'2': _stat[1]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();

                    }

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
                  if (_pressedseat == false&&_stat[2]==false) {
                    if (pressed[2] == false) {
                      _stat[2] = true;
                      pressed[2] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'3': _stat[2]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_3";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':3,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );
                    }
                  } else if(_pressedseat==true){
                    String docid=widget.bs.busNumber.toString()+"_3";
                    if (pressed[2] == true) {
                      _stat[2] = false;
                      pressed[2] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'3': _stat[2]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();
                    }
                    print('${_pressedseat}seatboolean');


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
                  if (_pressedseat == false) {
                    if (pressed[3] == false) {
                      _stat[3] = true;
                      pressed[3] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'4': _stat[3]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_4";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':4,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );
                    }
                  } else {
                    String docid=widget.bs.busNumber.toString()+"_4";
                    if (pressed[3] == true) {
                      _stat[3] = false;
                      pressed[3] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'4': _stat[3]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();
                    }
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
                  if (_pressedseat == false) {
                    if (pressed[4] == false) {
                      _stat[4] = true;
                      pressed[4] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'5': _stat[4]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_5";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':5,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );
                    }
                  } else {
                    String docid=widget.bs.busNumber.toString()+"_5";
                    if (pressed[4] == true) {
                      _stat[4] = false;
                      pressed[4] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'5': _stat[4]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();
                    }
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
                    if (_pressedseat == false) {
                      if (pressed[i] == false) {
                        _stat[i] = true;
                        pressed[i] = true;
                        _pressedseat = true;
                        print('pressed');
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+1}': _stat[i]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        String docid=widget.bs.busNumber.toString()+"_${i+1}";
                        final addUser = widget.fs.collection('reservations').doc(docid);
                        final use = {
                          'UID': widget.cus.uid,
                          'seatnumber':i+1,
                          'busNumber':widget.bs.busNumber,
                        };
                        addUser.set(use);
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                            new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                          ),
                        );
                      }
                    } else {
                      String docid=widget.bs.busNumber.toString()+"_${i+1}";
                      if (pressed[i] == true) {
                        _stat[i] = false;
                        pressed[i] = false;
                        _pressedseat = false;
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+1}': _stat[i]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        widget.fs.collection("reservations").doc(docid).delete();
                      }
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
                    if (_pressedseat == false) {
                      if (pressed[i + 1] == false) {
                        _stat[i + 1] = true;
                        pressed[i + 1] = true;
                        _pressedseat = true;
                        print('pressed');
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+2}': _stat[i + 1]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        String docid=widget.bs.busNumber.toString()+"_${i+2}";
                        final addUser = widget.fs.collection('reservations').doc(docid);
                        final use = {
                          'UID': widget.cus.uid,
                          'seatnumber':i+2,
                          'busNumber':widget.bs.busNumber,
                        };
                        addUser.set(use);
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                            new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                          ),
                        );
                      }
                    } else {
                      String docid=widget.bs.busNumber.toString()+"_${i+2}";
                      if (pressed[i + 1] == true) {
                        _stat[i + 1] = false;
                        pressed[i + 1] = false;
                        _pressedseat = false;
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+2}': _stat[i + 1]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        widget.fs.collection("reservations").doc(docid).delete();
                      }
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
                    if (_pressedseat == false) {
                      if (pressed[i + 3] == false) {
                        _stat[i + 3] = true;
                        pressed[i + 3] = true;
                        _pressedseat = true;
                        print('pressed');
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+3}': _stat[i + 2]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        String docid=widget.bs.busNumber.toString()+"_${i+3}";
                        final addUser = widget.fs.collection('reservations').doc(docid);
                        final use = {
                          'UID': widget.cus.uid,
                          'seatnumber':i+3,
                          'busNumber':widget.bs.busNumber,
                        };
                        addUser.set(use);
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                            new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                          ),
                        );
                      }
                    } else {
                      String docid=widget.bs.busNumber.toString()+"_${i+3}";
                      if (pressed[i + 2] == true) {
                        _stat[i + 2] = false;
                        pressed[i + 2] = false;
                        _pressedseat = false;
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+3}': _stat[i + 2]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        widget.fs.collection("reservations").doc(docid).delete();
                      }
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
                    if (_pressedseat == false) {
                      if (pressed[i + 3] == false) {
                        _stat[i + 3] = true;
                        pressed[i + 3] = true;
                        _pressedseat = true;
                        print('pressed');
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+4}': _stat[i + 3]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        String docid=widget.bs.busNumber.toString()+"_${i+4}";
                        final addUser = widget.fs.collection('reservations').doc(docid);
                        final use = {
                          'UID': widget.cus.uid,
                          'seatnumber':i+4,
                          'busNumber':widget.bs.busNumber,
                        };
                        addUser.set(use);
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                            new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                          ),
                        );
                      }
                    } else {
                      String docid=widget.bs.busNumber.toString()+"_${i+4}";
                      if (pressed[i + 3] == true) {
                        _stat[i + 3] = false;
                        pressed[i + 3] = false;
                        _pressedseat = false;
                        widget.fs
                            .collection("buses")
                            .doc(widget.bs.id)
                            .update({'${i+4}': _stat[i + 3]})
                            .then((value) => print("User Updated"))
                            .catchError((error) =>
                            print("Failed to update user: $error"));
                        widget.fs.collection("reservations").doc(docid).delete();
                      }
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
                  if (_pressedseat == false) {
                    if (pressed[49] == false) {
                      _stat[49] = true;
                      pressed[49] = true;
                      _pressedseat = true;
                      print('pressed');
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'50': _stat[49]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      String docid=widget.bs.busNumber.toString()+"_50";
                      final addUser = widget.fs.collection('reservations').doc(docid);
                      final use = {
                        'UID': widget.cus.uid,
                        'seatnumber':50,
                        'busNumber':widget.bs.busNumber,
                      };
                      addUser.set(use);
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          new ReceiptScreen(cus: widget.cus, bs:widget.bs,sta:widget.st),
                        ),
                      );

                    }
                  } else {
                    String docid=widget.bs.busNumber.toString()+"_50";

                    if (pressed[49] == true) {
                      _stat[49] = false;
                      pressed[49] = false;
                      _pressedseat = false;
                      widget.fs
                          .collection("buses")
                          .doc(widget.bs.id)
                          .update({'50': _stat[49]})
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                          print("Failed to update user: $error"));
                      widget.fs.collection("reservations").doc(docid).delete();
                    }
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

  @override
  void initState() {
    super.initState();
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
              pageBuilder: (_, __, ___) => new StationsScreen(cus: widget.cus)),
        );
      } else {
        Navigator.pushNamed(context, ProfileScreen.id);
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
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'profile',
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
      body: SafeArea(child: _buildSeats()),
    );
  }
}
