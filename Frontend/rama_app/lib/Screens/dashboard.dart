import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rama_app/Setup/model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  Model model;
  DatabaseReference _db;

  Dashboard(Model _model, DatabaseReference _db) {
    this.model = _model;
    this._db = _db;
  }
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  DatabaseReference dbRef;
  StreamSubscription<Event> _onLossAddedEvent;
  StreamSubscription<Event> _onAccuracyAddedEvent;
  int k = 0, z = 0;
  double CX, MX, CY, MY;
  double ACX, AMX, ACY, AMY;
  double X, Y;
  String epoch = "None";
  String lastLoss = "None";
  String lastAcc = "None";
  List<FlSpot> data, dataAcc;
  @override
  void initState() {
    super.initState();
    dbRef = widget._db;
    _onLossAddedEvent = dbRef.child("loss").onChildAdded.listen(_onLossAdd);
    _onAccuracyAddedEvent =
        dbRef.child("acc").onChildAdded.listen(_onAccuracyAdd);
    data = new List<FlSpot>();
    dataAcc = new List<FlSpot>();

    CX = CY = MX = MY = 0;
    ACX = ACY = AMX = AMY = 0;
  }

  _onAccuracyAdd(Event event) {
    setState(() {
      X = double.parse(event.snapshot.key);
      if(X.toInt() == 1){
        dataAcc.clear();
      }
      Y = event.snapshot.value;
      if (X > AMX) {
        AMX = X;
      }
      if (X < ACX) {
        ACX = X;
      }
      if (Y > AMY) {
        AMY = Y;
      }
      if (Y < ACY) {
        ACY = Y;
      }
      dataAcc.add(FlSpot(X, (Y * 10000).round() / 10000));
      lastAcc = dataAcc.last.y.toString();
      z = z + 1;
    });
  }

  _onLossAdd(Event event) {
    setState(() {
      X = double.parse(event.snapshot.key);
      if(X.toInt() == 1){
        data.clear();
      }
      Y = event.snapshot.value;
      if (X > MX) {
        MX = X;
      }
      if (X < CX) {
        CX = X;
      }
      if (Y > MY) {
        MY = Y;
      }
      if (Y < CY) {
        CY = Y;
      }

      data.add(FlSpot(X, (Y * 10000).round() / 10000));
      epoch = X.toInt().toString();
      lastLoss = data.last.y.toString();
      k = k + 1;
    });
  }

  Widget getMain(
      List<FlSpot> _data, double _CX, double _CY, double _MX, double _MY) {
    List<Color> gradientColors = [
      Theme.of(context).splashColor,
      Colors.blue,
    ];
    if(_data.length > 0) {
      return AspectRatio(
        aspectRatio: 1.70,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: FlChart(
              chart: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalGrid: true,
                    getDrawingVerticalGridLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.2,
                      );
                    },
                    getDrawingHorizontalGridLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 0.2,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 0,
                      textStyle: TextStyle(
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      getTitles: (value) {},
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                        color: Theme.of(context).splashColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      getTitles: (value) {
                      },
                      reservedSize: 0,
                    ),
                  ),
                  borderData: FlBorderData(
                      show: false,),
                  minX: _CX,
                  maxX: _MX,
                  minY: _CY,
                  maxY: _MY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _data,
                      isCurved: true,
                      colors: gradientColors,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                      ),
                      belowBarData: BelowBarData(
                        show: true,
                        colors: gradientColors
                            .map((color) => color.withOpacity(0.3))
                            .toList(),
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
    else{
      return Text("No data!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.red, widget.model.getColor(1)],
                    [Colors.blue, widget.model.getColor(2)],
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
      ),
        backgroundColor: Theme.of(context).splashColor,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: 10,
                    right: 10),
                child: Column(
                  children: <Widget>[

                    Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                                    child: Text(
                                      "Epoch",
                                      style: TextStyle(
                                          color: Theme.of(context).splashColor,
                                          fontSize: 20,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      epoch,
                                      style: TextStyle(
                                          color: Theme.of(context).splashColor,
                                          fontSize: 20,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ),
                                ],
                              ),
                              color: Colors.white,
                            ),

                              Expanded(
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 10),
                                        child: Text(
                                          "Last Update",
                                          style: TextStyle(
                                              color: Theme.of(context).splashColor,
                                              fontSize: 20,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          widget.model.lastUpdatedOn,
                                          style: TextStyle(
                                              color: Theme.of(context).splashColor,
                                              fontSize: 20,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  color: Colors.white,
                                )
                              ),

                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[

                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20,
                                      top: 20,
                                      right: 20,
                                      bottom: 20),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Loss",
                                        style: TextStyle(
                                            color: Theme.of(context).splashColor,
                                            fontSize: 20,
                                            fontFamily: 'Raleway'),
                                      ),
                                      Text(
                                        lastLoss,
                                        style: TextStyle(
                                            color: Theme.of(context).splashColor,
                                            fontSize: 15,
                                            fontFamily: 'Raleway'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: getMain(data, CX, CY, MX, MY),
                                ),
                              ],
                            )),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20,
                                      top: 20,
                                      right: 20,
                                      bottom: 20),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Accuracy",
                                        style: TextStyle(
                                            color: Theme.of(context).splashColor,
                                            fontSize: 20,
                                            fontFamily: 'Raleway'),
                                      ),
                                      Text(
                                        lastAcc,
                                        style: TextStyle(
                                            color: Theme.of(context).splashColor,
                                            fontSize: 15,
                                            fontFamily: 'Raleway'),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child:
                                  getMain(dataAcc, ACX, ACY, AMX, AMY),
                                ),
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
