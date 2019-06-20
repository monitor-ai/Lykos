import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class Model {
  String _id;
  String _name;
  DateTime _createdOn;
  DateTime _lastUpdatedOn;
  String _current;

  Model(this._id, this._name, this._createdOn, this._lastUpdatedOn, this._current);

  Model.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._createdOn = DateTime.parse(obj['createdOn']);
    this._lastUpdatedOn = DateTime.parse(obj['lastUpdatedOn']);
    this._current = obj['current'];
  }


  String get id => _id;
  String get name => _name;
  String get createdOn => timeago.format(_createdOn);
  String get lastUpdatedOn => timeago.format(_lastUpdatedOn);
  String get current => _current;

  Model.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _createdOn = DateTime.parse(snapshot.value['createdOn']);
    _lastUpdatedOn = DateTime.parse(snapshot.value['lastUpdatedOn']);
    _current = snapshot.value['current'].toString();
  }
}