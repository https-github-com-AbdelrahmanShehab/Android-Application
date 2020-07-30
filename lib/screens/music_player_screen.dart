import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../widgets/app_drawer.dart';
import '../services/music_service.dart';

class MusicPlayerScreen extends StatefulWidget {
  static const routeName = '/music-player';
  final AssetsAudioPlayer assetsAudioPlayer;
  MusicPlayerScreen(this.assetsAudioPlayer);
  @override
  _MusicPlayerScreenState createState() =>
      _MusicPlayerScreenState(assetsAudioPlayer);
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  String imageAsset = 'assets/image/JohnsonsBaby.jpg';
  bool isLooping = false;
  bool isMuted = false;
  double volume = 0.3;
  final musicService = MusicService();
  final AssetsAudioPlayer assetsAudioPlayer;
  _MusicPlayerScreenState(this.assetsAudioPlayer);


  @override
  void initState() {
    assetsAudioPlayer.isPlaying.listen((isPlaying) {
      assetsAudioPlayer.current.listen((songs) {
        changeImage(songs);
        musicService.updateFirebaseSong(isPlaying, songs.index);
      });
    });
    musicService.updateFirebaseVolume(volume);

    super.initState();
  }

  void changeImage(Playing songs) {
    int songIndex = songs.index;
    if (songIndex == 0) {
      imageAsset = 'assets/image/JohnsonsBaby.jpg';
    }
    if (songIndex == 1) {
      imageAsset = 'assets/image/LullabyGoodnight.jpg';
    }
    if (songIndex == 2) {
      imageAsset = 'assets/image/PrettyLittle.jpg';
    }
    if (songIndex == 3) {
      imageAsset = 'assets/image/RockabyeBaby.jpg';
    }
    if (songIndex == 4) {
      imageAsset = 'assets/image/Twinkle.png';
    }
   
    setState(() {});
  }

 
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music Player',
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            fontSize: 25,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(22, 22, 22, 0.4),
      ),
      extendBodyBehindAppBar: true,
      drawer: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color.fromRGBO(22, 22, 22,0.5) 
            ),
        child: AppDrawer(assetsAudioPlayer),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(73, 17, 15, 1),
                Color.fromRGBO(8, 40, 75, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: _size.width,
          height: _size.height,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: _size.width * 0.5,
                      height: _size.height * 0.35,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.volume_off,
                                color:
                                    isMuted ? Colors.white : Colors.grey[550],
                                size: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
                                });
                                if (isMuted) {
                                  assetsAudioPlayer.setVolume(0);
                                }
                                if (!isMuted) {
                                  assetsAudioPlayer.setVolume(volume);
                                }
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.skip_previous,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    assetsAudioPlayer.previous();
                                  }),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: IconButton(
                                    icon: PlayerBuilder.isPlaying(
                                        player: assetsAudioPlayer,
                                        builder: (context, isPlaying) {
                                          return isPlaying
                                              ? Icon(Icons.pause,
                                                  color: Colors.white, size: 40)
                                              : Icon(Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 40);
                                        }),
                                    onPressed: () {
                                      assetsAudioPlayer.playOrPause();
                                    }),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    assetsAudioPlayer.next();
                                  }),
                            ],
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.loop,
                                color:
                                    isLooping ? Colors.white : Colors.grey[550],
                                size: 25,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLooping = !isLooping;
                                });
                                assetsAudioPlayer.loop = isLooping;
                              }),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.volume_down,
                          color: Colors.white,
                          size: 25,
                        ),
                        Slider(
                          min: 0.0,
                          max: 1.0,
                          onChanged: (newValue) {
                            volume = newValue;
                            musicService.updateFirebaseVolume(volume);
                            setState(() {});
                          },
                          value: volume,
                        ),
                        Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 25,
                        ),
                      ],
                    ),
                    Text(
                      'Control Baby\'s Room',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  assetsAudioPlayer.playlistPlayAtIndex(0);
                },
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          ExactAssetImage('assets/image/JohnsonsBaby.jpg')),
                  title: Text(
                    'Johnsons Baby',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  assetsAudioPlayer.playlistPlayAtIndex(1);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/image/LullabyGoodnight.jpg'),
                  ),
                  title: Text(
                    'Lullaby Goodnight',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  assetsAudioPlayer.playlistPlayAtIndex(2);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage('assets/image/PrettyLittle.jpg'),
                  ),
                  title: Text(
                    'Pretty Little Baby',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  assetsAudioPlayer.playlistPlayAtIndex(3);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage('assets/image/RockabyeBaby.jpg'),
                  ),
                  title: Text(
                    'Rockabye Baby',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  assetsAudioPlayer.playlistPlayAtIndex(4);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        ExactAssetImage('assets/image/Twinkle.png'),
                  ),
                  title: Text(
                    'Twinkle',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
