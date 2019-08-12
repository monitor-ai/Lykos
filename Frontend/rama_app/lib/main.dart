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
  String id = "NULL", _email="NULL";

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
          id = x;
          status = 1;
        }
      });
    });
  }
  final dbInstance = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    Widget home = null;

    dbInstance.setPersistenceEnabled(true);
    dbInstance.setPersistenceCacheSizeBytes(10000000);

    DatabaseReference db = dbInstance.reference();

    if(status == 1){
      _userRepository.getUserEmail().then((String email){
        setState(() {
          _email = email;
        });
      });
      _userRepository.currentUser().then((String x){
        setState(() {
          id = x;
        });
      });
      if(id != "NULL") {
        home = HomePage(_userRepository, _signedOut, db, id, _email);
      }
      else{
        home = Container(
          height: 100,
          child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
        );
      }
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
        color: Colors.white,
        theme: ThemeData(
            primaryColor: Color(0xFF3c75d1),
            splashColor: Color(0xFF3c75d1),
            accentColor: Color(0xFF3264b5),
            buttonColor: Color(0xFF3c75d1),
            backgroundColor: Colors.white
        ),

        home: home,

    );
  }

}