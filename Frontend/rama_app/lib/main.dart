import 'package:flutter/material.dart';
import './Setup/login.dart';
import './Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Setup/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(App());

}  //runApp

class App extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}
class _AppState extends State<App>{
  UserRepository _userRepository =  UserRepository(firebaseAuth: FirebaseAuth.instance);
  int status = 0;

  void _signedIn() {
    setState(() {
      status = 1;
    });
  }

  void _signedOut() {
    setState(() {
      status = 0;
    });
  }

  final db = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    Widget home = null;
    if(_userRepository.getUser()!=null){
      status = 1;
    }
    if(status == 1){
      home = HomePage(_userRepository, _signedOut, db);
    }
    else{
      home = Login(_userRepository, _signedIn);
    }
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rama App",

        theme: ThemeData(
            primaryColor: Color(0xFF3c75d1),
            accentColor: Color(0xFF3264b5),
            buttonColor: Color(0xFF3c75d1),
            backgroundColor: Color(0xFFEFEFEF)
        ),

        home: home
    );
  }

}