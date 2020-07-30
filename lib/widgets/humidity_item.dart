import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../services/status_service.dart';

class HumidityItem extends StatefulWidget {
  final double humidity;
  HumidityItem(this.humidity);
  @override
  _HumidityItemState createState() => _HumidityItemState(humidity);
}

class _HumidityItemState extends State<HumidityItem> {
   StatusService _humidityStatus = StatusService();
  StreamSubscription _subscription;
  static const String directory = 'Status/Humidity';
  double _humditiyLevel;

  _HumidityItemState(this._humditiyLevel);


  Color get humditiyStatus {
    if (_humditiyLevel >= 0.3 && _humditiyLevel <= 0.5) {
      return Color.fromRGBO(0, 255, 0, 1);
    } else if ((_humditiyLevel >= 0.2 && _humditiyLevel < 0.3) || (_humditiyLevel > 0.5 && _humditiyLevel <= 0.6))  {
      return Color.fromRGBO(255, 255, 0, 1);
    } else {
      return Color.fromRGBO(255, 0, 0, 1);
    }
  }

  @override
  void initState() {
    _humidityStatus.getStatusStream(directory,_updateTemp)
        .then((StreamSubscription s) => _subscription = s);
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  _updateTemp(Event event) {
    setState(() {
      _humditiyLevel = double.parse(event.snapshot.value) / 100;
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(22, 22, 22, 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularPercentIndicator(
                radius: (0.6 * constraints.maxWidth),
                lineWidth: 3.0,
                percent: _humditiyLevel <= 1.0 && _humditiyLevel >= 0.0
                    ? _humditiyLevel
                    : 0,
                center: Text(
                  "${(_humditiyLevel * 100).round()} %",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: humditiyStatus,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Color.fromRGBO(32, 32, 32, 1),
                progressColor: humditiyStatus,
              ),
            ),
            Text(
              'Humditity',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
