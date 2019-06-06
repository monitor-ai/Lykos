import 'package:flutter/material.dart';
import './Setup/login.dart';

void main() {

  runApp(FlutterApp());

}  //runApp

class FlutterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Rama App",
        theme: ThemeData(
          primaryColor: Color(0xFF3c75d1),
          accentColor: Color(0xFF3264b5),
          buttonColor: Color(0xFF3c75d1),
        ),

      home: LoginPage()
    );
  }

}