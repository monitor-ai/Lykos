import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';


class NewModel extends StatefulWidget{
  DatabaseReference _db;
  String _uid;
  NewModel(DatabaseReference db, String _uid){
    this._db = db;
    this._uid = _uid;
  }
  @override
  State<StatefulWidget> createState() {
    return _NewModelState();
  }
}
class _NewModelState extends State<NewModel>{
  DatabaseReference modelRef;
  final formKey = GlobalKey<FormState>();
  String ModelName;
  String ModelKey;
  List<MaterialColor> colors = Colors.primaries;
  Random random = new Random();
  String barcode = "None";
  FocusNode _focusNode = new FocusNode();
  var txt = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

      modelRef = widget._db.child(widget._uid).child("models");
      return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        backgroundColor: Theme
            .of(context)
            .splashColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("New Model", style: TextStyle(fontFamily: "Raleway", color: Colors.white),),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).splashColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.save, color: Theme.of(context).splashColor,),
            backgroundColor: Colors.white,
            label: Text("Save", style: TextStyle(color: Theme.of(context).splashColor),),
            onPressed: save,
        ),
        body: Container(
          margin: EdgeInsets.all(20),
            child:
            Form(

              key: formKey,
              child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 100),
                      child:
                      Hero(
                        child: Icon(Icons.book, size: 100, color: Colors.white,),
                        tag: "newModel",
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Container(

                            margin: EdgeInsets.only(top:10, bottom: 10, right: 10),
                            child:TextFormField(
                              controller: txt,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return "Unique ID is empty!";
                                }
                              },
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                                  labelText: "Unique ID",
                                  errorStyle: TextStyle(color: Colors.yellow),
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Raleway")),
                              onSaved: (input) => ModelKey = input,
                            ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: scan,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(100)),
                          padding: EdgeInsets.all(20),

                          child: Text("SCAN",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Raleway')),

                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top:10, bottom: 10),
                      child:TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Model Name is empty!";
                          }
                        },
                        style: TextStyle(
                            color: Colors.white
                        ),
                        focusNode: _focusNode,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10))),
                            labelText: "Model Name",
                            errorStyle: TextStyle(color: Colors.yellow),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow), borderRadius: BorderRadius.all(Radius.circular(10))),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: "Raleway")),
                        onSaved: (input) => ModelName = input,
                      ),
                    ),

                  ]
              ),
            ),
        ),
      );
    }
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState((){
        this.barcode = barcode;
        txt.text = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Camera permission was not granted!")));
      } else {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Unknown Error: " + e.code)));
      }
    } on FormatException{
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("User pressed back button before scanning!")));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Unknown Error: " + e.code)));
    }
  }
  void save(){
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      modelRef.child(this.barcode).update({
        'name': ModelName,
        'createdOn': DateTime.now().toString(),
        'lastUpdatedOn': DateTime.now().toString(),
        'colors': json.encode({
          'color1': colors[random.nextInt(colors.length)].value.toRadixString(16).substring(2, 8),
          'color2': colors[random.nextInt(colors.length)].value.toRadixString(16).substring(2, 8),
          'color3': colors[random.nextInt(colors.length)].value.toRadixString(16).substring(2, 8),
          'color4': colors[random.nextInt(colors.length)].value.toRadixString(16).substring(2, 8),
        },
        ),
        'current': '1',
      });
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Model Added successfully")));

      Navigator.pop(context);
    }
  }
}