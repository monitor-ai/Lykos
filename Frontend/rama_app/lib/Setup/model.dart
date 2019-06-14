import 'package:firebase_database/firebase_database.dart';

class Model {
  String _id;
  String _name;

  Model(this._id, this._name);

  Model.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
  }


  String get id => _id;
  String get name => _name;

  Model.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
  }
}