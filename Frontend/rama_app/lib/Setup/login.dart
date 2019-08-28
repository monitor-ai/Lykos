import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'user_repository.dart';
import 'package:firebase_database/firebase_database.dart';

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

class _LoginState extends State<Login>{
  String _email, _password;
  bool loading = false;
  String _firstName, _lastName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  int animationStatus = 0;
  AnimationController _controller;
  double initialWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Widget form = null;
    if(widget.formType == true){
      form = loginForm();
    }
    else{
      form = registerForm();
    }
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: form,
    );
  }

  Widget registerForm(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light
    ));
    return Container(
      color: Theme.of(context).splashColor,
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
        child:Container(
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
                ))))));
  }

  Widget loginForm(){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: Brightness.light// navigation bar color
    ));
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).splashColor,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                                              onPressed: signIn,
                                              color: Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(100)),
                                              padding: EdgeInsets.all(20),

                                              child: Text("SIGN IN",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Raleway')),

                                            ),

                                          ),
                                          /*
                                      PhysicalModel(
                                          color: Theme.of(context).primaryColor,
                                          elevation: calculateElevation(),
                                          borderRadius: BorderRadius.circular(100),
                                          child: Container(
                                            key: _globalKey,
                                            height: 60,
                                            width: _width,
                                            child: RaisedButton(
                                              padding: EdgeInsets.all(20),
                                              color: _state == 2 ? Colors.green : Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(100)),

                                              child: buildButtonChild(),
                                              onPressed: () {},
                                              onHighlightChanged: (isPressed) {
                                                setState(() {
                                                  _isPressed = isPressed;
                                                  if (_state == 0) {
                                                    signIn();
                                                  }
                                                });
                                              },
                                            ),
                                          )),

                                       */
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
                    )))),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
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
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Registering user...")));
            await widget._userRepository.signUp(_email, _password);
            String uid = await widget._userRepository.currentUser();
            widget._db.child(uid).set({
              'fName': _firstName,
              'lName': _lastName
            });
            widget._signedIn();
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Registration successful!")));

          } catch (e) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("User already exists!")));

          }
        }
      }
    } on SocketException catch (_) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Please check your internet connectivity!")));

    }
  }

  Future<void> signIn() async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Logging you in...")));
            await widget._userRepository.signInWithCredentials(_email, _password);
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Logged In!")));
            widget._signedIn();

          } catch (e) {
            _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Wrong Username/Password!")));

          }
        }
      }
    } on SocketException catch (_) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Please check your internet connectivity!")));

    }

  }
}

