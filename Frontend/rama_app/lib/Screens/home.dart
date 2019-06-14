import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rama_app/Setup/login.dart';
import 'package:rama_app/Setup/model.dart';
import '../Setup/user_repository.dart';
import '../Setup/FABBottomAppBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newmodel.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  UserRepository _userRepository;
  VoidCallback _signedOut;
  DatabaseReference _db;
  String _id;
  HomePage(UserRepository _userRepository, VoidCallback _signedOut,
      DatabaseReference db, String id) {
    this._userRepository = _userRepository;
    this._signedOut = _signedOut;
    this._db = db;
    this._id = id;
  }
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Model> models;
  String _email = "";
  String _name = "";
  String _fName= "", _lName="";
  int _x = 0;
  bool loading = false;
  StreamSubscription<Event> _onModelAddedSubscription;
  StreamSubscription<Event> _onModelChangedSubscription;

  DatabaseReference modelsRef;

  @override
  void initState() {
    super.initState();
    models = new List();
    modelsRef =  widget._db.child(widget._id).child('models');
    _onModelAddedSubscription = modelsRef.onChildAdded.listen(_onModelAdd);

  }

  void _selectedTab(int index) {
    setState(() {
      _x = index;
      if (_x == 1) {
        _showBottomDialog(context);
      }
    });
  }
  @override
  void dispose() {
    _onModelAddedSubscription.cancel();
    _onModelChangedSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness:
            Brightness.dark // navigation bar color
        ));
    if (_email == "" || loading == true) {

      widget._userRepository.getUserEmail().then((String x) {
        setState(() {
          _email = x;
        });
      });
      return Container(
        height: 100,
        child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
      );
    } else {

      //_onModelChangedSubscription = modelsRef.onChildChanged.listen(_onModelUpdate);

      return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "RAMA App",
            style: TextStyle(fontFamily: "Raleway", color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        bottomNavigationBar: FABBottomAppBar(
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
            FABBottomAppBarItem(
                iconData: Icons.account_circle, text: 'Profile'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewModel(widget._db, widget._id)));
          },
          tooltip: 'Add new Model',
          label: Text("New Model"),
          icon: Icon(Icons.book),
          elevation: 4.0,
          heroTag: "newModel",
        ),
        body: Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child:  Flexible(
                    child:FirebaseAnimatedList(
                      query: modelsRef,
                      itemBuilder: (BuildContext bc, DataSnapshot ds, Animation<double> animation, int index){

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Wrap(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.book, size: 50,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(models[index].name, style: TextStyle(fontSize: 20),),
                                          Text(models[index].id, style: TextStyle(fontSize: 15),)
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                      }
                  ),
                  ),

                  ),


              ],
            )),
      );
    }
  }
  _onModelAdd(Event event){
    setState(() {
      loading = true;
    });
    setState(() {
      models.add(new Model.fromSnapshot(event.snapshot));
      loading = false;
    });
  }
  _showDialog(title, text, okButton) {
    showDialog(
      context: context,
      builder: (context) {
        List<Widget> actions = null;
        Widget content = null;
        if (okButton == true) {
          actions = <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ];
          content = Text(
            text,
            textAlign: TextAlign.center,
          );
        } else {
          actions = <Widget>[];
          content = Container(
            height: 100,
            child: SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
          );
        }
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          content: content,
          actions: actions,
        );
      },
      barrierDismissible: okButton,
    );
  }

  void _showBottomDialog(context) {
    if(_fName == "" && _lName == "") {
      showModalBottomSheet(context: context, builder: (BuildContext bc) {
        return Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: new Wrap(
              children: <Widget>[
                SpinKitDoubleBounce(color: Theme
                    .of(context)
                    .primaryColor),
              ]
          ),

        );
      });
      widget._db.child(widget._id).once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> x = snapshot.value;
        dynamic first, last;
        x.forEach((key, value) {
          if (key == "fName") {
            first = value;
          } else if(key == "lName"){
            last = value;
          }
        });
        setState(() {
          _fName = first.toString();
          _lName = last.toString();
          Navigator.pop(context);
          _showBottomDialog(context);
        });
      });
    }
    else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                      currentAccountPicture: Icon(
                        Icons.account_circle,
                        size: 75,
                        color: Colors.white,
                      ),
                      accountName: new Text(
                        _fName + " " + _lName,
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                      accountEmail: new Text(
                        _email,
                        style: new TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      )),
                  new ListTile(
                    leading: new Icon(Icons.exit_to_app),
                    title: new Text('Log Out'),
                    onTap: signOut,
                  ),
                ],
              ),
            );
          });
    }
  }

  void signOut() async {
    try {
      await widget._userRepository.signOut();
      Navigator.pop(context);
      widget._signedOut();
    } catch (e) {
      print(e);
    }
  }
}
