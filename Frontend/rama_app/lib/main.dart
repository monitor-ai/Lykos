import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './Setup/login.dart';
import './Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Setup/user_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

void main() {

  runApp(App());

}  //runApp

class App extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}
class _AppState extends State<App> with TickerProviderStateMixin {
  UserRepository _userRepository =  UserRepository(firebaseAuth: FirebaseAuth.instance);
  int status = -1;
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userRepository.currentUser().then((String x){
      setState(() {
        if(x == null){
          status = 0;
        }
        else{
          status = 1;
        }
      });
    });
  }
  final db = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    Widget home = null;

    if(status == 1){
      home = HomePage(_userRepository, _signedOut, db);
    }
    else if(status == 0){
      home = Login(_userRepository, _signedIn, db);
    }
    else if(status == -1){
      home = Container(
        height: 100,
        child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
      );
    }
    else{
      home = null;
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

        home: Material(
          child: home,
        )
    );
  }

}