import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import '../services/auth_service.dart';
import './wrapper.dart';
import '../screens/home_screen.dart';
import '../screens/camera_Screen.dart';
import '../screens/music_player_screen.dart';
import '../services/music_service.dart';

class AppDrawer extends StatelessWidget {
  final AuthService auth = AuthService();
  final musicService = MusicService();
  final AssetsAudioPlayer assetsAudioPlayer;
  AppDrawer(this.assetsAudioPlayer);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Color.fromRGBO(22, 22, 22, 0.4),
            title: Text('Navigate to '),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.home,color: Colors.white),
            title: Text('Home',style: TextStyle(color: Colors.white),),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(Icons.camera_alt,color: Colors.white),
            title: Text('Camera',style: TextStyle(color: Colors.white),),
            onTap: () =>
                Navigator.of(context).pushNamed(CameraScreen.routeName),
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(Icons.queue_music,color: Colors.white),
            title: Text('Music Player',style: TextStyle(color: Colors.white),),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(MusicPlayerScreen.routeName),
          ),
          Divider(color: Colors.white),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.white),
            title: Text('Log Out',style: TextStyle(color: Colors.white),),
            onTap: () async {
              try {
                if (assetsAudioPlayer.isPlaying.value) {
                  await assetsAudioPlayer.playlistPlayAtIndex(0);
                  await assetsAudioPlayer.pause();
                  await musicService.updateFirebaseSong(false, 1);
                }
              } catch (e) {}
              await auth.signOUt();
              Navigator.of(context).pushReplacementNamed(Wrapper.routeName);
            },
          ),
        ],
      ),
    );
  }
}
