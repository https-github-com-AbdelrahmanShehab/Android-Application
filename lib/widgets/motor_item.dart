import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../services/controller_service.dart';

class MotorItem extends StatefulWidget {
  final int run;
  final double level;
  MotorItem(this.run,this.level);
  @override
  _MotorItemState createState() => _MotorItemState(run,level);
}

class _MotorItemState extends State<MotorItem> {
  ControllerService _motorController = ControllerService();
  StreamSubscription _subscription;
  static const String directory = 'Motor';
  int _buttonStatus ;
  double _sliderValue ;
  String _sliderLable;

  _MotorItemState(this._buttonStatus,this._sliderValue);

  @override
  void initState() {
    _motorController
        .getStatusStream(directory, _onMotorChange)
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

  _onMotorChange(Event event) {
    setState(() {
      _buttonStatus = event.snapshot.value['run'];
      _sliderValue = (event.snapshot.value['level']).toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(22, 22, 22, 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (ctx, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (_buttonStatus == 1) {
                  _buttonStatus = 0;
                } else {
                  _buttonStatus = 1;
                }
                _motorController.updateItem(
                    directory, _buttonStatus, _sliderValue);
                setState(() {});
              },
              child: Container(
                  width: constraints.maxWidth * 0.45,
                  child: _buttonStatus == 1
                      ? Image.asset(
                          'assets/image/power_on.png',
                        )
                      : Image.asset(
                          'assets/image/power_off.png',
                        )),
            ),
            Slider(
              min: 1.0,
              max: 3.0,
              value: _sliderValue,
              onChanged: (newValue) {
                setState(() {
                  _sliderValue = newValue;
                  if (_sliderValue == 1.0) {
                    _sliderLable = "Low";
                  }
                  if (_sliderValue > 1.0 && _sliderValue <= 2.0) {
                    _sliderLable = "Medium";
                  }
                  if (_sliderValue > 2.0 && _sliderValue <= 3.0) {
                    _sliderLable = "High";
                  }
                });
                 _motorController.updateItem( directory, _buttonStatus, _sliderValue);
              },
              divisions: 2,
              label: _sliderLable,
            ),
            FittedBox(
              child: Text(
                'Motor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
