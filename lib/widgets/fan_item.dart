import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/controller_service.dart';

class FanItem extends StatefulWidget {
  final int run;
  final double level;
  FanItem(this.run, this.level);
  @override
  _FanItemState createState() => _FanItemState(run, level);
}

class _FanItemState extends State<FanItem> {
  ControllerService _fanController = ControllerService();
  StreamSubscription _subscription;
  static const String directory = 'Fan';
  int _buttonStatus;
  double _sliderValue;
  String _sliderLable;

  _FanItemState(this._buttonStatus, this._sliderValue);

  @override
  void initState() {
    _fanController
        .getStatusStream(directory, _onFanChange)
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

  _onFanChange(Event event) {
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
                _fanController.updateItem(
                    directory, _buttonStatus, _sliderValue);
                setState(() {});
              },
              child: Container(
                  width: constraints.maxWidth * 0.45,
                  child: _buttonStatus == 1
                      ? Image.asset(
                          'assets/image/fan_on.png',
                        )
                      : Image.asset(
                          'assets/image/fan_off.png',
                        )),
            ),
            Slider(
              min: 1.0,
              max: 3.0,
              value: _sliderValue,
              onChanged: (newValue) {
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
                _fanController.updateItem(
                    directory, _buttonStatus, _sliderValue);
                setState(() {});
              },
              divisions: 2,
              label: _sliderLable,
            ),
            FittedBox(
              child: Text(
                'Fan',
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
