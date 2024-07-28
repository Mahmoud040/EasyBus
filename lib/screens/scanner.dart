
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'Receipt2.dart';
import 'package:flash_chat/Station.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Bus.dart';
import 'package:flash_chat/components/roundedbutton.dart';
import 'package:flash_chat/screens/Receipt2.dart';
import 'package:flash_chat/screens/seats.dart';





class Scanner extends StatefulWidget {
  final Customer cus;
  final Station sta;
  final Bus bs;
  FirebaseFirestore fs = FirebaseFirestore.instance;

   Scanner({Key key,  this.title,this.cus,this.sta,this.bs}) : super(key: key);



/*  This widget is the home page of your application. It is stateful, meaning
  that it has a State object (defined below) that contains fields that affect
  how it looks.

  This class is the configuration for the state. It holds the values (in this
  case the title) provided by the parent (in this case the App widget) and
  used by the build method of the State. Fields in a Widget subclass are
  always marked "final".*/

  final String title;

  @override
  State<Scanner> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode result;
  QRViewController controller;

 /* In order to get hot reload to work we need to pause the camera if the platform
  is android, or resume the camera if the platform is iOS.*/
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.resumeCamera();
    } else if (Platform.isIOS) {
      controller.pauseCamera();
    }
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
  int _Reser;


  @override
  Widget build(BuildContext context) {
    getReservations().then((value) {
      // print(value);
      //print("im ass");
      //*setState(() {*//*
      _Reser = value;
      //* });*//*
    });

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(

            flex: 1,
            child: Center(
              child: (result != null)

                  ? Roundedbutton(title: '  Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}',onPressed:(){

                widget.fs

                    .collection("Users")
                    .doc(widget.cus.uid)
                    .update({"points":widget.cus.points-10 })
                    .then((value) => print("User Updated"),)
                    .catchError((error) =>
                    print("Failed to update user: $error"));
                    Customer cs=new Customer(uid: widget.cus.uid,email: widget.cus.email,username: widget.cus.username,password: widget.cus.password,points: widget.cus.points-10);
                    /*Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
          new StationsScreen(cus: cs),
        ),
      );*/
                Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
          new Receipt2Screen(cus: cs, bs:widget.bs,sta:widget.sta),
        ),
      );
              },)
                  : Roundedbutton(title: 'Cancel',onPressed: (){
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

              },),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      /*Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
          new Receipt2Screen(cus: widget.cus, bs:widget.bs,sta:widget.sta),
        ),
      );*/

    });
  }

}

