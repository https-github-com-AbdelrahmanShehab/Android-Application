import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'services/auth_service.dart';
import './services/music_service.dart';
import './screens/home_screen.dart';
import './screens/auth_screen.dart.dart';
import './screens/camera_Screen.dart';
import './screens/music_player_screen.dart';
import './widgets/wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final musicService = MusicService();
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  final List<Audio> audios = [
    Audio("assets/audios/JohnsonsBaby.mp3"),
    Audio("assets/audios/LullabyGoodnight.mp3"),
    Audio("assets/audios/PrettyLittleHorses.mp3"),
    Audio("assets/audios/RockabyeBaby.mp3"),
    Audio("assets/audios/Twinkle.mp3"),
  ];

  @override
  void initState() {
    assetsAudioPlayer.open(
        Playlist(
          audios: audios,
        ),
        autoStart: false
        );
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return StreamProvider<String>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Baby Monitor',
        home: Wrapper(),
        routes: {
          Wrapper.routeName: (ctx) => Wrapper(),
          AuthScreen.routeName: (ctx) => AuthScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(assetsAudioPlayer),
          CameraScreen.routeName: (ctx) => CameraScreen(),
          MusicPlayerScreen.routeName: (ctx) =>
              MusicPlayerScreen(assetsAudioPlayer),
        },
      ),
    );
  }
}
