import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rama_app/Screens/home.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
