import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';
import '../Setup/user_repository.dart';
import '../Setup/FABBottomAppBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dashboard.dart';
import 'newmodel.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../Setup/logoAnimation.dart';

class HomePage extends StatefulWidget {
  UserRepository _userRepository;
  VoidCallback _signedOut;
  DatabaseReference _db;
  String _id;
  String _email;
  HomePage(UserRepository _userRepository, VoidCallback _signedOut,
      DatabaseReference db, String id, String _email) {
    this._userRepository = _userRepository;
    this._signedOut = _signedOut;
    this._db = db;
    this._id = id;
    this._email = _email;
  }
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class DataSearch extends SearchDelegate<Model>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){},)
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,),
      onPressed: () {
        close(context, null);
      },
    );
  }
  @override
  void close(BuildContext context, Model result) {
    super.close(context, result);
  }
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text("Results"),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Text("Results"),
    );
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Model> models;
  String _email = "NULL";
  String _fName = "NULL", _lName = "NULL";
  int _x = 0;
  StreamSubscription<Event> _onModelAddedSubscription;
  StreamSubscription<Event> _onModelChangedSubscription;
  AnimationController _controller;
  double pad = 0;
  DatabaseReference modelsRef;

  @override
  void initState() {
    super.initState();
    models = new List();
    print(widget._id);
    modelsRef = widget._db.child(widget._id).child("models");
    _onModelAddedSubscription = modelsRef.onChildAdded.listen(_onModelAdd);
    _onModelChangedSubscription = modelsRef.onChildChanged.listen(_onModelChange);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
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

  void search() {}
  void profile() {}
  List<Widget> getRow() {
    return <Widget>[
      InkWell(
        child: Icon(
          Icons.search,
          color: Theme.of(context).splashColor,
        ),
        onTap: (){
          showSearch(context: context, delegate: DataSearch());
        },
        splashColor: Colors.grey,
      ),
      Flexible(
        child: Container(
            alignment: Alignment.center,
            child: StaggerAnimation(
              controller: _controller.view,
            )),
      ),
      InkWell(
        child: CircleAvatar(
          backgroundColor: Theme.of(context).splashColor,
          child: Text(_fName[0] + _lName[0]),
        ),
        onTap: profile,
        splashColor: Colors.transparent,
      ),
    ];
  }
  MaskFilter _blur;
  final List<MaskFilter> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  void openModelDash(int index){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(models[index], modelsRef.child(models[index].id))));
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    if (_fName == "NULL" && _lName == "NULL" && _email == "NULL") {
      widget._db.child(widget._id).once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> x = snapshot.value;
        dynamic first, last;
        x.forEach((key, value) {
          if (key == "fName") {
            first = value;
          } else if (key == "lName") {
            last = value;
          }
        });
        setState(() {
          _fName = first.toString();
          _lName = last.toString();
          _email = widget._email;
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
          backgroundColor: Theme.of(context).splashColor,
          bottomNavigationBar: FABBottomAppBar(
            onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
              FABBottomAppBarItem(iconData: Icons.settings, text: 'Settings'),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
            hoverElevation: 10,
          ),
          body: CustomScrollView(

            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(top: 15),
              ),
              //The Top Bar with search
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title:
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Material(
                      child: InkWell(
                        child: Row(
                          children: getRow(),
                        ),
                        splashColor: Colors.grey,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                  ),
                ),
                floating: true,
                expandedHeight: 80,
              ),
              models.isEmpty?SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext bc, int index){
                  return Center(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 150),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.book, color: Colors.white54,size: 100,),
                          Text("No models available!", style: TextStyle(color: Colors.white54),),
                          Text("Click on New Model to add new models", style: TextStyle(color: Colors.white54),)

                        ],
                      ),
                    ),
                  );
                }, childCount: 1),

              ):
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext bc, int index){
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Dismissible(
                        key: Key(
                            index.toString() + models.length.toString()),
                        background: Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            color: Theme.of(context).splashColor,
                            child: Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ))),
                        confirmDismiss: _confirmDismiss,
                        onDismissed: (direction) {
                          if (models.contains(models[index])) {
                            setState(() {
                              widget._db
                                  .child(widget._id)
                                  .child("models")
                                  .child(models[index].id)
                                  .remove();
                            });
                            models.removeAt(index);
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 124,
                              margin: EdgeInsets.only(left: 46, bottom: 10+pad),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10.0,
                                        offset: Offset(0.0, 10.0))
                                  ]),
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(

                                  onTap: () { openModelDash(index); },

                                  splashColor: Colors.grey,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(left: 70, top: 15),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          models[index].name,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: "Raleway"
                                          ),
                                        ),
                                        Text(
                                          models[index].id,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Raleway"
                                          ),
                                        ),
                                        Text(
                                          models[index].lastUpdatedOn,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Raleway"
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                ,
                                )
                              ),
                            Container(
                              margin:
                              new EdgeInsets.symmetric(vertical: 16.0),
                              alignment: FractionalOffset.centerLeft,

                              child: ClipOval(
                                child:  WaveWidget(

                                  config: CustomConfig(
                                    gradients: [
                                      [Colors.red, models[index].getColor(1)],
                                      [Colors.blue, models[index].getColor(2)],
                                      [Colors.green, models[index].getColor(3)],
                                      [Colors.yellow, models[index].getColor(4)]
                                    ],
                                    durations: [35000, 19440, 10800, 6000],
                                    heightPercentages: [0.20, 0.23, 0.25, 0.30],
                                    blur: MaskFilter.blur(BlurStyle.solid, 10),
                                    gradientBegin: Alignment.bottomLeft,
                                    gradientEnd: Alignment.topRight,
                                  ),
                                  waveAmplitude: 0,
                                  backgroundColor: Colors.blue,
                                  size: Size(90, 90),

                                ),
                              ),
                            ),

                          ],
                        )
                    ),
                  );
                },
                  childCount: models.length
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: 30),
              )
            ],
          )
      );
    }
  }

  Future<bool> _confirmDismiss(direction) async {
    bool x = await _showDialog(
        "Do you want to remove model?", "Click yes if you want to remove", 1);
    return x;
  }

  _onModelAdd(Event event) {
    setState(() {
      models.insert(0, new Model.fromSnapshot(event.snapshot));
    });
  }
  _onModelChange(Event event){
    var oldModel = models.singleWhere((model) => model.id == event.snapshot.key);
    setState(() {
      models[models.indexOf(oldModel)] = Model.fromSnapshot(event.snapshot);
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

  Future<bool> _showDialog(title, text, id) async {
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
        content = Text(
          text,
          textAlign: TextAlign.center,
        );

        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
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
