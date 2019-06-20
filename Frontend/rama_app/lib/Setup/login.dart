import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rama_app/Screens/home.dart';
import 'dart:io';
import 'user_repository.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'loginAnimation.dart';

class Login extends StatefulWidget {
  UserRepository _userRepository;
  VoidCallback _signedIn;
  bool formType = true;
  DatabaseReference _db;

  Login(UserRepository _userRepository, VoidCallback _signedIn, DatabaseReference db){
    this._userRepository = _userRepository;
    this._signedIn = _signedIn;
    this._db = db;
  }
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }

}

class _LoginState extends State<Login> {
  String _email, _password;
  bool loading = false;
  String _firstName, _lastName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext context;
  int animationStatus = 0;
  AnimationController _loginButtonController;

  @override
  void initState() {
    super.initState();


  }
  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    this.context = context;
    if(widget.formType == true){
      return loginForm();
    }
    else{
      return registerForm();
    }
  }

  Widget registerForm(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light
    ));
    return Container(
        color: Theme.of(context).splashColor,
        child: Container(
            alignment: Alignment.center,
            child: Container(

                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: <Widget>[

                    Card(
                        elevation: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        margin: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Wrap(children: <Widget>[

                          Form(
                              key: _formKey,
                              child: Container(
                                  margin: EdgeInsets.all(40),
                                  width: double.infinity,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                "Register",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'Raleway'),
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Icon(
                                                Icons.assignment,
                                                color: Theme.of(context).primaryColor,
                                                size: 50,
                                              )
                                          ),
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child:

                                          TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "First Name is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.account_circle),
                                                labelText: "First Name",
                                                labelStyle: TextStyle(
                                                    fontFamily: "Raleway")),
                                            onSaved: (input) => _firstName = input,
                                          )



                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child:

                                          TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Last Name is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.supervised_user_circle),
                                                labelText: "Last Name",
                                                labelStyle: TextStyle(
                                                    fontFamily: "Raleway")),
                                            onSaved: (input) => _lastName = input,
                                          )



                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child:

                                          TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Email Address is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.email),
                                                labelText: "Email",
                                                labelStyle: TextStyle(
                                                    fontFamily: "Raleway")),
                                            onSaved: (input) => _email = input,
                                          )
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 30),
                                          child: TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Password is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.lock),
                                              labelText: "Password",
                                              labelStyle: TextStyle(
                                                  fontFamily: "Raleway"),
                                            ),
                                            obscureText: true,
                                            onSaved: (input) =>
                                            _password = input,
                                          )),


                                      Container(

                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 0),
                                        width: double.infinity,
                                        child: RaisedButton(
                                          onPressed: registerIn,
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(100)),
                                          padding: EdgeInsets.all(20),

                                          child: Text("REGISTER",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Raleway')),

                                        ),

                                      ),


                                      Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Already a user? ",
                                                style: TextStyle(
                                                  fontFamily: "Raleway",
                                                  fontSize: 15,
                                                ),
                                              ),
                                              InkWell(
                                                child: Text(
                                                  "Login",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontFamily: "Raleway",
                                                    fontSize: 15,
                                                  ),

                                                ),
                                                onTap: changeForm,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ))),
                        ]))
                  ],
                ))));
  }



  Widget loginForm(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light// navigation bar color
    ));
    return Container(
        color: Theme.of(context).splashColor,
        child: Container(
            alignment: Alignment.center,
            child: Container(

                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 100,
                        )
                    ),
                    Card(
                        elevation: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        margin: EdgeInsets.only(
                            top: 20, bottom: 10, left: 20, right: 20),
                        child: Wrap(children: <Widget>[
                          Form(
                              key: _formKey,
                              child: Container(
                                  margin: EdgeInsets.all(40),
                                  width: double.infinity,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Text(
                                                "Sign In",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontFamily: 'Raleway'),
                                              )),

                                        ],
                                      ),

                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child:

                                          TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Email Address is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.email),
                                                labelText: "Email",
                                                labelStyle: TextStyle(
                                                    fontFamily: "Raleway")),
                                            onSaved: (input) => _email = input,
                                          )



                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 30),
                                          child: TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Password is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.lock),
                                              labelText: "Password",
                                              labelStyle: TextStyle(
                                                  fontFamily: "Raleway"),
                                            ),
                                            obscureText: true,
                                            onSaved: (input) =>
                                            _password = input,
                                          )),



                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 0),
                                          width: double.infinity,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(100)),
                                            padding: EdgeInsets.all(20),
                                            onPressed: signIn,

                                            child: Text("SIGN IN",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway')),
                                            color:
                                            Color.fromRGBO(60, 117, 209, 1),
                                          )

                                      ),




                                      Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "New User? ",
                                                style: TextStyle(
                                                  fontFamily: "Raleway",
                                                  fontSize: 15,
                                                ),
                                              ),
                                              InkWell(
                                                child: Text(
                                                  "Register",
                                                  style: TextStyle(
                                                    color: Theme.of(context).primaryColor,
                                                    fontFamily: "Raleway",
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                onTap: changeForm,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ))),
                        ]))
                  ],
                ))));
  }
  void invalid(){

  }
  void changeForm(){
    if(widget.formType == false){
      setState(() {
        widget.formType = true;
      });
    }
    else{
      setState(() {
        widget.formType = false;
      });
    }
  }
  void registerIn() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            setState(() {
              loading= true;
            });
            await widget._userRepository.signUp(_email, _password);
            String uid = await widget._userRepository.currentUser();
            widget._db.child(uid).set({
              'fName': _firstName,
              'lName': _lastName
            });
            Navigator.of(context).pop();
            widget._signedIn();

          } catch (e) {
            Navigator.of(context).pop();
            setState(() {
              loading = false;
            });
          }
        }
      }
    } on SocketException catch (_) {
        setState(() {
          loading = false;
        });
      }
  }
  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    }
    on TickerCanceled{}
  }
  Future<void> signIn() async {
    _playAnimation();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            setState(() {
              loading=true;
            });
            await widget._userRepository.signInWithCredentials(_email, _password);
            widget._signedIn();

          } catch (e) {
            setState(() {
              loading=false;
            });
          }
        }
      }
    } on SocketException catch (_) {
      setState(() {
        loading=false;
      });
    }

  }
}

