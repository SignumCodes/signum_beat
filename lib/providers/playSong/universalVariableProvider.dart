import 'package:flutter/material.dart';
// import 'package:on_audio_query/on_audio_query.dart';

import '../../api/jiosaavn/models/song.dart';


class UniVarProvider with ChangeNotifier {

  static final UniVarProvider _instance = UniVarProvider._internal();

  factory UniVarProvider() {
    return _instance;
  }

  UniVarProvider._internal();

  // List<SongModel> _searchSong = [];
  static List<dynamic> _data = [];
  static List<dynamic> _recentData = [];
  List<SongResponse> _playerQueue = [];
  List<dynamic> _favouriteSong = [];

  // List<SongModel> get searchSong => _searchSong;
  static  List<dynamic> get data => _data;
  static set data(List<dynamic> value) {
    _data = value;
  }

  static shuffleDataList(){
    _data.shuffle();
    _instance.notifyListeners();
  }

  List<dynamic> get recentData => _recentData;
  List<SongResponse> get playerQueue => _playerQueue;
  List<dynamic> get favouriteSong => _favouriteSong;

  /*void addRecentSong(SongModel song) {
    if (_recentData.any((recentSong) => recentSong == song)) {
      return;
    }
    if (_recentData.length > 30) {
      _recentData.removeLast(); // Remove the oldest item if the list exceeds the maximum size
    } else {
      _recentData.insert(0, song);
    }
    notifyListeners();
  }*/

  // Additional methods to manipulate the lists can be added here
 /* void addToSearchSong(SongModel song) {
    _searchSong.add(song);
    notifyListeners();
  }*/

  void addToData(dynamic item) {
    _data.add(item);
    notifyListeners();
  }

  void addToPlayerQueue(SongResponse song) {
    _playerQueue.add(song);
    notifyListeners();
  }

  void addToFavouriteSong(dynamic song) {
    _favouriteSong.add(song);
    notifyListeners();
  }

  void removeFromFavouriteSong(dynamic song) {
    _favouriteSong.remove(song);
    notifyListeners();
  }
}
