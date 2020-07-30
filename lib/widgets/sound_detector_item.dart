import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/status_service.dart';

class SoundDetectorItem extends StatefulWidget {
  final String sound;
  SoundDetectorItem(this.sound);
  @override
  _SoundDetectorItemState createState() => _SoundDetectorItemState(sound);
}

class _SoundDetectorItemState extends State<SoundDetectorItem> {
  StatusService _soundStatus = StatusService();
  StreamSubscription _subscription;
  static const String directory = 'Sound Detection/detected';
  String _sound;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  _SoundDetectorItemState(this._sound);

  @override
  void initState() {
    _soundStatus
        .getStatusStream(directory, _updateSound)
        .then((StreamSubscription s) => _subscription = s);
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  _updateSound(Event event) {
    setState(() {
      _sound = event.snapshot.value;
    });
    if (_sound == 'yes') {
      assetsAudioPlayer.open(Audio("assets/audios/Baby01.mp3"));
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: constraints.maxWidth * 0.6,
              child: _sound == 'yes'
                  ? Image.asset('assets/image/listen_on.png')
                  : Image.asset('assets/image/listen_off.png'),
            ),
            FittedBox(
              child: Text(
                'Sound Detector',
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
