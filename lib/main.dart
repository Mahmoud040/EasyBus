import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/Station1.dart';
import 'package:flash_chat/screens/seats.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/stations_screen.dart';
import 'screens/Station1.dart';
import 'package:flash_chat/screens/Receipt.dart';
import 'package:flash_chat/screens/Profile.dart';
import 'package:flash_chat/screens/driverSeats.dart';
import 'package:flash_chat/screens/Receipt2.dart';


void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  //
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF193044),

        ),
          canvasColor: Colors.orange,
        scaffoldBackgroundColor:Color(0xFF193044),
      ),

      //home: WelcomeScreen(),
      initialRoute:WelcomeScreen.id,
      routes: {
        Receipt2Screen.id:(context)=>Receipt2Screen(),
        DriverSeatsScreen.id:(context)=>DriverSeatsScreen(),
        ProfileScreen.id:(context)=>ProfileScreen(),
        ReceiptScreen.id:(context)=>ReceiptScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        RegistrationScreen.id:(context)=>RegistrationScreen(),
        StationsScreen.id:(context)=>StationsScreen(),
        SeatsScreen.id:(context)=>SeatsScreen(),
        Station1Screen.id:(context)=>Station1Screen(),
      },
    );
  }
}
