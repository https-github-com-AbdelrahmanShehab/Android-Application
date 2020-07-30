import 'dart:async';
import 'dart:convert';

import '../widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

import '../util/color.dart';
import '../services/status_service.dart';
import '../services/auth_service.dart';
import '../services/music_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/motor_item.dart';
import '../widgets/camera_live.dart';
import '../widgets/fan_item.dart';
import '../widgets/humidity_item.dart';
import '../widgets/temperature_item.dart';
import '../widgets/sound_detector_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final AssetsAudioPlayer assetsAudioPlayer;
  HomeScreen([this.assetsAudioPlayer]);

  @override
  _HomeScreenState createState() => _HomeScreenState(assetsAudioPlayer);
}

class _HomeScreenState extends State<HomeScreen> {
  StatusService _home = StatusService();
  final AuthService auth = AuthService();
  final musicService = MusicService();
  final AssetsAudioPlayer assetsAudioPlayer;
  _HomeScreenState(this.assetsAudioPlayer);
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    _fcm.getToken().then((token) => print(token));
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () => null,
          ),
        );

         Scaffold.of(context).showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baby Actions',
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            fontSize: 25,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(22, 22, 22, 0.6),
      ),
      extendBodyBehindAppBar: true,
      drawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(22, 22, 22,0.5) ),
        child: AppDrawer(assetsAudioPlayer),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 120),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffb92b27),
              Color(0xff1565C0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder(
          future: _home.getStatusOnce(""),
          builder: (BuildContext context, AsyncSnapshot future) {
            if (future.hasError) {
              return Center(
                child: Text(
                  "Error Occured, Please log out and try again",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (future.hasData) {
              final homeData = future.data.value;
              final status = homeData['Status'];
              final motor = homeData['Motor'];
              final fan = homeData['Fan'];
              final sound = homeData['Sound Detection'];
              return GridView(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 1 / 1),
                children: <Widget>[
                  MotorItem(motor['run'], motor['level'].toDouble()),
                  FanItem(fan['run'], fan['level'].toDouble()),
                  TemperatureItem(double.parse(status['Temperature'])),
                  HumidityItem(double.parse(status['Humidity']) / 100),
                  SoundDetectorItem(sound['detected']),
                  CameraLiveItem(),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
