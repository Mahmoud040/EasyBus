import 'package:flash_chat/screens/driverSeats.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedbutton.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/Customer.dart';
import 'package:flash_chat/Driver.dart';
import 'package:flash_chat/Bus.dart';
const colorizeColors = [
  Colors.orange,
  Colors.orangeAccent,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
];

const colorizeTextStyle = TextStyle(
  fontSize: 50.0,
  fontFamily: 'Horizon',
);

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore fs=FirebaseFirestore.instance;
  Animation animation;
  String email;
  String password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(

      duration: Duration(seconds: 1),
      vsync: this,
      //upperBound: 100.0
    );

    animation = ColorTween(begin: Color(0xFF8AB4F8), end: Color(0xFF193044))
        .animate(controller);

    controller.forward();
    animation.addStatusListener((status) {});

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Easy BUS',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation:true,
                ),
              ],
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
                    hintText: 'Email')),
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
                  hintText: 'Password'),
            ),
            SizedBox(
              height: 30.0,
            ),
            Roundedbutton(
              title: 'Log in',
              colour: Colors.orange,
              onPressed: () async {
                try {
                  final newUser1 = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser1 != null) {
                    var uid=newUser1.user.uid.toString();
                    var type="";
                    fs.collection("Users").doc(uid).get().then((DocumentSnapshot documentSnapshot){
                      if(documentSnapshot.exists)
                        {
                          type= documentSnapshot.get('type');

                          var Username=documentSnapshot.get('Username');




                          if(type=='Customer') {
                            var points=documentSnapshot.get('points');

                            Customer _user = new Customer(username: Username,email: email,password: password,uid:uid,points: points);
                            Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                    pageBuilder: (_, __,
                                        ___) => new StationsScreen(cus:_user)));

                          }
                          else{
                            var busNo=documentSnapshot.get('busNumber');
                            Bus bs1;
                             fs.collection("buses").get().then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                var busNumber = doc["busNumber"];
                                var id = doc.id;
                                var route = doc["route"];
                                var station = doc["station"];
                                if (busNo==busNumber) {
                                  Bus bs = new Bus(
                                      id: id,
                                      busNumber: busNumber,
                                      route: route,
                                      station: station);

                                  bs1=bs;
                                  var stationNo=documentSnapshot.get('stationNumber');
                                  Driver _driver = new Driver(username: Username,email: email,password: password,uid:uid,busNo: busNo,stationNo:stationNo);
                                  Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __,
                                              ___) => new DriverSeatsScreen(cus:_driver,bs: bs,)));

                                }

                                //print(stationName);
                              });
                            });
                            print("------------${bs1.id}---------");




                          }

                        }
                    });

                    //Navigator.pushNamed(context, StationsScreen.id);
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
              title: 'Sign up',
              colour: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }
}
