import 'package:flutter/material.dart';
import 'package:rama_app/Screens/home.dart';
import 'dart:io';
import 'user_repository.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Login extends StatefulWidget {
  UserRepository _userRepository;
  VoidCallback _signedIn;
  bool formType = true;

  Login(UserRepository _userRepository, VoidCallback _signedIn){
    this._userRepository = _userRepository;
    this._signedIn = _signedIn;
  }
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }

}

class _LoginState extends State<Login>{
  String _email, _password;
  String _firstName, _lastName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext context;

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
    return Container(
        color: Theme.of(context).primaryColor,
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
                                                icon: Icon(Icons.account_circle),
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
                                                icon: Icon(Icons.supervised_user_circle),
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
                                                icon: Icon(Icons.email),
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
                                              icon: Icon(Icons.lock),
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
    return Container(
        color: Color.fromRGBO(60, 117, 209, 1),
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
                                                icon: Icon(Icons.email),
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
                                              icon: Icon(Icons.lock),
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
                                                    color: Colors.white,
                                                    fontFamily: 'Raleway')),
                                            color:
                                            Color.fromRGBO(60, 117, 209, 1),
                                          )),
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
            _showDialog("Registering you...", "Please wait while we register you!", false);
            await widget._userRepository.signUp(_email, _password);
            Navigator.of(context).pop();
            widget._signedIn();

          } catch (e) {
            Navigator.of(context).pop();
            _showDialog("Error", "Wrong Username or Password", true);
          }
        }
      }
    } on SocketException catch (_) {
      _showDialog("No Internet Access", "Please enable Wi-Fi or Mobile Data to continue", true);
    }
  }
  Future<void> signIn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            _showDialog("Signing in...", "Please wait while we sign you in!", false);
            await widget._userRepository.signInWithCredentials(_email, _password);
            Navigator.of(context).pop();
            widget._signedIn();

          } catch (e) {
            Navigator.of(context).pop();
            _showDialog("Error", "Wrong Username or Password", true);
          }
        }
      }
    } on SocketException catch (_) {
      _showDialog("No Internet Access", "Please enable Wi-Fi or Mobile Data to continue", true);
    }

  }
  _showDialog(title, text, okButton) {
    showDialog(
      context: context,
      builder: (context) {
        List<Widget> actions = null;
        Widget content = null;
        if(okButton == true){
          actions = <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ];
          content = Text(text, textAlign: TextAlign.center,);
        }
        else{
          actions = <Widget>[];
          content = Container(
            height: 100,
            child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
          );
        }
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: content,
          actions: actions,
        );
      },
      barrierDismissible: okButton,
    );
  }
}

