import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'dart:convert';


class Model {
  String _id;
  String _name;
  DateTime _createdOn;
  DateTime _lastUpdatedOn;
  String _current;
  var c;

  Model(this._id, this._name, this._createdOn, this._lastUpdatedOn, this._current);

  Model.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._createdOn = DateTime.parse(obj['createdOn']);
    this._lastUpdatedOn = DateTime.parse(obj['lastUpdatedOn']);
    this._current = obj['current'];
    var data = json.decode(obj['colors'].toString()) as Map;
    this.c = data.cast<String, String>();
  }

  Color _hexToColor(String code) {
    return new Color(int.parse(code, radix: 16) + 0xFF000000);
  }

  String get id => _id;
  String get name => _name;
  String get createdOn => timeago.format(_createdOn);
  String get lastUpdatedOn => timeago.format(_lastUpdatedOn);
  DateTime get lastUpdatedOnTime => _lastUpdatedOn;
  DateTime get createdOnTime => _createdOn;

  String get current => _current;

  Color getColor(int i){
    return _hexToColor(c['color' + i.toString()]);
  }


  Model.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _createdOn = DateTime.parse(snapshot.value['createdOn']);
    _lastUpdatedOn = DateTime.parse(snapshot.value['lastUpdatedOn']);
    _current = snapshot.value['current'].toString();
    var data = json.decode(snapshot.value['colors'].toString()) as Map;
    c = data.cast<String, String>();
  }
}