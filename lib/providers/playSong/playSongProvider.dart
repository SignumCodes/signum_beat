import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query_android_v1_8/';
import '../../api/jiosaavn/models/song.dart';
import '../permistion_provider.dart';
import 'universalVariableProvider.dart';


class PlaySongProvider with ChangeNotifier {
  // final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  final permissionHandlerProvider = PermissionProvider();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  int _playIndex = 0;
  bool _isPlaying = false;
  String _duration = '';
  String _position = '';
  double _max = 0.0;
  double _value = 0.0;
  String _playerProcessingState = '';
  dynamic _playingModSong;

  late Animation<Color?> _colorAnimation;
  Animation<Color?> get colorAnimation => _colorAnimation;

  int get playIndex => _playIndex;

  set playIndex(int value) {
    _playIndex = value;
    notifyListeners();
  }

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    if (_isPlaying != value) {
      _isPlaying = value;
      notifyListeners();
    }
  }


  bool _isHeartRed = false;

  bool get isHeartRed => _isHeartRed;

  set isHeartRed(bool value) {
    if (_isHeartRed != value) {
      _isHeartRed = value;
      notifyListeners();
    }
  }


  String get duration => _duration;

  String get position => _position;

  double get max => _max;

  double get value => _value;

  String get playerProcessingState => _playerProcessingState;

  dynamic get playingModSong => _playingModSong;


  PlaySongProvider() {
    init();
  }

  Future<void> init() async {

    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: androidInitialize);
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    audioPlayer.playerStateStream.listen((playerState) {
      audioPlayer.processingStateStream.listen((processingState) {
        if (processingState == ProcessingState.ready) {
          print('Audio source is ready to play.');
        }
      });
      playerState.processingState.name == 'loading'
          ? _playerProcessingState = 'loading'
          : _playerProcessingState = 'idle';
      _isPlaying = playerState.playing;
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
    });
  }

  void playSong(dynamic song, int index) {
    _playIndex = index;
    try {
      /*if (song is SongModel) {
        _playingModSong = song;
        audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      } else */
        if (song is SongResponse) {
        _playingModSong = song;
        audioPlayer.setAudioSource(
            AudioSource.uri(Uri.parse(song.downloadUrl!.last.link)));
      }
      audioPlayer.play();
      _isPlaying = true;
      // _showNotification(song);
      updatePosition();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void play(String url) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
      audioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void playNextSong() {
    try {
      // Check if there are songs in the playlist
      if (UniVarProvider.data.isEmpty) {
        print('No songs in the playlist');
        audioPlayer.stop();
        _isPlaying = false;
        notifyListeners();
        return;
      }

      // Determine the next index
      int nextIndex;
      if (_playIndex < UniVarProvider.data.length - 1) {
        nextIndex = _playIndex + 1;
      } else {
        // If at the last song, loop back to the first song
        nextIndex = 0;
      }

      // Get the next song
      var nextSong = UniVarProvider.data[nextIndex];

      // Play the next song
      playSong(nextSong, nextIndex);
    } catch (e) {
      print('Error playing next song: $e');
      // Fallback to stopping playback if something goes wrong
      audioPlayer.stop();
      _isPlaying = false;
    }

    notifyListeners();
  }

  void updatePosition() {
    audioPlayer.durationStream.listen((d) {
      if (d != null) {
        _duration = d.toString().split(".")[0];
        _max = d.inSeconds.toDouble();
      } else {
        _duration = "0:00";
        _max = 0.0;
      }
      notifyListeners();
    });

    audioPlayer.positionStream.listen((p) {
      _position = p.toString().split(".")[0];
      _value = p.inSeconds.toDouble();
      notifyListeners();
    });
  }

  void changeDurationToSecond(int second) {
    var duration = Duration(seconds: second);
    audioPlayer.seek(duration);
  }

  suffleList() {
    UniVarProvider.data.shuffle();
    notifyListeners();
  }



  Future<void> _showNotification(dynamic song) async {
    const androidDetails = AndroidNotificationDetails(
      'com.example.app.audio', // ID for the channel
      'Music Playback',
      channelDescription: 'Music playback controls',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Show notification with song info
    await flutterLocalNotificationsPlugin.show(
      0,
      'Now Playing',
      // song is SongModel ? song.title :
       song.downloadUrl!.last.link,
      platformDetails,
      payload: 'payload', // Optionally pass any payload
    );

    // Update notification progress
    await flutterLocalNotificationsPlugin.show(
      1,
      'Now Playing',
      'Progress: $_position / $_duration',
      platformDetails,
      payload: 'payload',
    );
  }
}