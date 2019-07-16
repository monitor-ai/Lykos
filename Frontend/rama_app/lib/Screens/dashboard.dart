import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:math' as math;
import 'package:bezier_chart/bezier_chart.dart';

class Dashboard extends StatefulWidget{
  Model model;
  DatabaseReference _db;

  Dashboard(Model _model, DatabaseReference _db){
    this.model = _model;
    this._db = _db;
  }
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }

}
class _DashboardState extends State<Dashboard>{

  List<double> X = new List<double>();
  List<DataPoint<dynamic>> Y = new List<DataPoint<dynamic>>();
  DatabaseReference dbRef;
  
  @override
  void initState() {
    super.initState();
    dbRef = widget._db;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Theme.of(context).splashColor,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .padding
                    .top + 10, left: 10
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BackButton(
                      color: Colors.white,
                    ),
                    ClipOval(
                      child:  WaveWidget(

                        config: CustomConfig(
                          gradients: [
                            [Colors.red, widget.model.getColor(1)],
                            [Colors.blue,widget.model.getColor(2)],
                            [Colors.green, widget.model.getColor(3)],
                            [Colors.yellow, widget.model.getColor(4)]
                          ],
                          durations: [35000, 19440, 10800, 6000],
                          heightPercentages: [0.20, 0.23, 0.25, 0.30],
                          blur: MaskFilter.blur(BlurStyle.solid, 10),
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                        waveAmplitude: 0,
                        backgroundColor: Colors.blue,
                        size: Size(30, 30),

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      widget.model.name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.topLeft,
                  child: Text(

                    "Loss",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Y.length > 0 ?
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: BezierChart(
                        bezierChartScale: BezierChartScale.CUSTOM,
                        xAxisCustomValues: X,
                        series: [
                        BezierLine(
                          lineColor: Theme.of(context).splashColor,
                          label: "m",
                          data: Y,
                        ),
                      ],
                          config: BezierChartConfig(
                            footerHeight: 40,
                            verticalIndicatorStrokeWidth: 3.0,
                            verticalIndicatorColor: Colors.black26,
                            showVerticalIndicator: true,
                            verticalIndicatorFixedPosition: false,

                            snap: false,
                      )
                    ),
                  ),
                ),
                ):Container(
              child:Text("No elements")
          )
              ],
            ),
          ),

        ],
      )
    );
  }

}