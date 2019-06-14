import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rama_app/Setup/login.dart';
import '../Setup/user_repository.dart';
import '../Setup/FABBottomAppBar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'newmodel.dart';


class HomePage extends StatefulWidget {
  UserRepository _userRepository;
  VoidCallback _signedOut;
  DatabaseReference _db;
  HomePage(UserRepository _userRepository, VoidCallback _signedOut, DatabaseReference db) {
    this._userRepository = _userRepository;
    this._signedOut = _signedOut;
    this._db = db;
  }
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _email = "";
  String _name = "";
  String _uid = "";
  int _x = 0;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark// navigation bar color
    ));
    if (_email == "") {
      widget._userRepository.currentUser().then((String uid){
        setState(() {
          _uid = uid;
        });
      });
      if(_uid.length > 0) {
        print("In here!");
        DatabaseReference temp = widget._db.child(_uid);
        temp.once().then((DataSnapshot snapshot) {
          Map<String, String> values = snapshot.value;
          values.forEach((keys, value) {
            setState(() {
              print(value);
            });
          });
        });
      }
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewModel(widget._db, _email)));
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
                Text("Currently Running Model"),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  width: double.infinity,
                  child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Text(_email),
                        ],
                      )),
                ),
                Text("Trained Model"),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Text(_email),
                        ],
                      )),
                ),
              ],
            )),
      );
    }
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
                      _name,
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
