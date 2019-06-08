import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rama_app/Screens/home.dart';
import 'register.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class LoginPage extends StatelessWidget {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
        color: Color.fromRGBO(60, 117, 209, 1),
        child: Container(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(top: 100),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/images/user.jpg',
                        height: 100,
                        width: 100,
                        color: Colors.white,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Card(
                        elevation: 50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.only(
                            top: 50, bottom: 10, left: 20, right: 20),
                        child: Wrap(children: <Widget>[
                          Form(
                              key: _formKey,
                              child: Container(
                                  margin: EdgeInsets.all(40),
                                  width: double.infinity,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontFamily: 'Raleway'),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: TextFormField(
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return "Email Address is empty!";
                                              }
                                            },
                                            decoration: InputDecoration(
                                                labelText: "Email",
                                                labelStyle: TextStyle(
                                                    fontFamily: "Raleway")),
                                            onSaved: (input) => _email = input,
                                          )),
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

                                                    fontFamily: "Raleway",
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                onTap: openRegister,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ))),
                        ]))
                  ],
                ))));
  }

  void openRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }
  Future<void> signIn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            _showDialog("Signing in...", "Please wait while we sign you in!", false);
            FirebaseUser user = await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password);
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
            Navigator.of(context).pop();

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

