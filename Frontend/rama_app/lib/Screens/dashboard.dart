import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:fl_chart/fl_chart.dart';

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
  DatabaseReference dbRef;
  StreamSubscription<Event> _onLossAddedEvent;
  StreamSubscription<Event> _onAccuracyAddedEvent;
  int k = 0, z= 0;
  double CX, MX, CY, MY;
  double ACX, AMX, ACY, AMY;
  double X, Y;

  List<FlSpot> data, dataAcc;
  @override
  void initState() {
    super.initState();
    dbRef = widget._db;
    _onLossAddedEvent = dbRef.child("loss").onChildAdded.listen(_onLossAdd);
    _onAccuracyAddedEvent = dbRef.child("acc").onChildAdded.listen(_onAccuracyAdd);
    data = new List<FlSpot>();
    dataAcc = new List<FlSpot>();

    CX = CY = MX = MY = 0;
    ACX = ACY = AMX = AMY = 0;
  }
  _onAccuracyAdd(Event event){
    setState(() {
      X = double.parse(event.snapshot.key);
      Y = event.snapshot.value;
      if(X > AMX){
        AMX = X;
      }
      if(X < ACX){
        ACX = X;
      }
      if(Y > AMY){
        AMY = Y;
      }
      if(Y < ACY){
        ACY = Y;
      }

      dataAcc.add(FlSpot(X, (Y*10000).round()/10000));
      z = z + 1;
    });
  }
  _onLossAdd(Event event) {
    setState(() {
      X = double.parse(event.snapshot.key);
      Y = event.snapshot.value;
      if(X > MX){
        MX = X;
      }
      if(X < CX){
        CX = X;
      }
      if(Y > MY){
        MY = Y;
      }
      if(Y < CY){
        CY = Y;
      }

      data.add(FlSpot(X, (Y*10000).round()/10000));
      k = k + 1;
    });
  }
  Widget getMain(List<FlSpot> _data, double _CX, double _CY, double _MX, double _MY){
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            color: Color(0xff232d37)
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: FlChart(
            chart: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalGrid: true,
                  getDrawingVerticalGridLine: (value) {
                    return const FlLine(
                      color: Color(0xff37434d),
                      strokeWidth:  1,
                    );
                  },
                  getDrawingHorizontalGridLine: (value) {
                    return const FlLine(
                      color: Color(0xff37434d),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 0,
                    textStyle: TextStyle(
                        color: const Color(0xff68737d),
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    getTitles: (value) {
                    },

                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(
                      color: const Color(0xff67727d),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    getTitles: (value) {
                    },
                    reservedSize: 0,

                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Color(0xff37434d), width: 1)
                ),
                minX: _CX,
                maxX: _MX,
                minY: _CY,
                maxY: _MY,
                lineBarsData: [
                  LineChartBarData(
                    spots: _data,
                    isCurved: true,
                    colors: gradientColors,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BelowBarData(
                      show: true,
                      colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                    .top + 10, left: 10, right: 10
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

                data.length > 0 ?
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    color: Color(0xff232d37),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left:20, top:20, right: 20, bottom: 20),
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Loss", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Raleway'),),
                                Text(data.last.y.toString(), style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),)

                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: getMain(data, CX, CY, MX, MY),
                          ),

                        ],
                      )
                    ),
                  ),
                ):Container(
                    child:Text("No elements")
                ),
                dataAcc.length > 0 ?
                Container(
                  margin: EdgeInsets.all(10),
                  child: Card(
                    color: Color(0xff232d37),
                    child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left:20, top:20, right: 20, bottom: 20),
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Accuracy", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Raleway'),),
                                  Text(dataAcc.last.y.toString(), style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Raleway'),)

                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: getMain(dataAcc, ACX, ACY, AMX, AMY),
                            ),

                          ],
                        )
                    ),
                  ),
                ):Container(
                    child:Text("No elements")
                ),
              ],
            ),
          ),

        ],
      )
    );
  }

}