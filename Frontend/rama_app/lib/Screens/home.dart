import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';
import '../Setup/user_repository.dart';
import '../Setup/FABBottomAppBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newmodel.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../Setup/logoAnimation.dart';

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
  String _fName= "", _lName="";
  int _x = 0;
  StreamSubscription<Event> _onModelAddedSubscription;
  StreamSubscription<Event> _onModelChangedSubscription;
  AnimationController _controller;

  DatabaseReference modelsRef;

  @override
  void initState() {
    super.initState();
    models = new List();

    modelsRef =  widget._db.child(widget._id).child("models");
    _onModelAddedSubscription = modelsRef.onChildAdded.listen(_onModelAdd);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this
    );
    _controller.forward();
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
    _controller.dispose();
  }
  void search(){

  }
  void profile(){

  }
  List<Widget> getRow() {

      return <Widget>[
        InkWell(
          child: Icon(Icons.search, color: Theme.of(context).splashColor,),
          onTap: search,
          splashColor: Colors.grey,
        ),

        Flexible(
          child: Container(
            alignment: Alignment.center,
            child: StaggerAnimation(
              controller: _controller.view,
            )

          ),
        ),
        InkWell(
          child: CircleAvatar(
            backgroundColor: Theme
                .of(context)
                .splashColor,
            child: Text(_fName[0] + _lName[0]),

          ),
          onTap: profile,
          splashColor: Colors.transparent,
        ),

      ];
  }
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    if (_fName == "" && _lName == "" && _email == "") {
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
        });
      });
      widget._userRepository.getUserEmail().then((String email){
        setState(() {
          _email = email;
        });
      });
      return Container(
        color: Colors.white,
        height: 100,
        child: SpinKitDoubleBounce(color: Theme.of(context).splashColor),
      );
    } else {

      //_onModelChangedSubscription = modelsRef.onChildChanged.listen(_onModelUpdate);
      return Scaffold(

        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.white,

        bottomNavigationBar: FABBottomAppBar(
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
            FABBottomAppBarItem(
                iconData: Icons.settings, text: 'Settings'),
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
            margin: EdgeInsets.only(top:40, left: 10, right: 10),
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: getRow(),
                        ),
                      ),
                      onTap: search,
                      splashColor: Colors.grey,

                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:15, bottom: 15),
                  color: Colors.white,
                  child:  Text(

                    "Currently Training Models",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromRGBO(0, 0, 0, 0.5)
                    ),
                  ),
                ),
                Container(
                    child:Flexible(
                      child: FirebaseAnimatedList(
                        scrollDirection: Axis.vertical,
                        query: modelsRef,
                        itemBuilder: (BuildContext bc, DataSnapshot ds, Animation<double> animation, int index){

                          return Dismissible(
                            key: Key(index.toString() + models.length.toString()),
                            background: Container(padding:EdgeInsets.only(left: 20, right: 20), color: Colors.red, child:
                            Center(
                                child:
                                Icon(Icons.delete, color: Colors.white,)

                            )
                            ),
                            confirmDismiss: _confirmDismiss,
                            onDismissed: (direction){
                              if(models.contains(models[index])) {
                                setState(() {

                                  widget._db.child(widget._id).child(
                                      "models")
                                      .child(models[index].id)
                                      .remove();
                                });
                                models.removeAt(index);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                color: Colors.white,

                                child: Wrap(
                                  children: <Widget>[

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[

                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(Icons.book, size: 60),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[

                                                Text(models[index].name, style: TextStyle(fontSize: 20),),
                                                Text(models[index].id, style: TextStyle(fontSize: 15),),
                                                Text("Last Updated: " + models[index].lastUpdatedOn, style: TextStyle(fontSize: 10),)
                                              ],
                                            ),


                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(models[index].createdOn, style: TextStyle(fontSize: 10),)
                                          ],
                                        ),

                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),

                            ),
                          );

                        },
                      ),

                    )

                ),
              ],
            )

        )

      );
    }
  }
  Future<bool> _confirmDismiss(direction) async{
    bool x = await _showDialog("Do you want to remove model?", "Click yes if you want to remove", 1);
    return x;
  }
  _onModelAdd(Event event){
    setState(() {
      models.insert(0, new Model.fromSnapshot(event.snapshot));
    });
  }


  void _showBottomDialog(context) {

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
  Future<bool> _showDialog(title, text, id) async{
    bool ret = false;
    await showDialog(
      context: context,
      builder: (context) {
        List<Widget> actions = null;
        Widget content = null;

          actions = <Widget>[

            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                ret = false;
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                ret = true;
              },
            ),
          ];
          content = Text(text, textAlign: TextAlign.center,);

        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: content,
          actions: actions,
        );
      },
      barrierDismissible: false,
    );
    return ret;
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
