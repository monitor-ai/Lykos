import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';

class Dashboard extends StatefulWidget{
  Model model;
  Dashboard(Model _model){
    this.model = _model;
  }
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }

}
class _DashboardState extends State<Dashboard>{
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(widget.model.id),
    );
  }

}