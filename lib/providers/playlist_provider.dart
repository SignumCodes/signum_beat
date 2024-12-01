import 'package:flutter/cupertino.dart';

import '../api/jiosaavn/jiosaavn.dart';
import '../api/jiosaavn/models/playlist.dart';
import '../api/jiosaavn/models/song.dart';

class PlaylistProvider extends ChangeNotifier{

  // final String id;
  final JioSaavnClient jio = JioSaavnClient();
  // PlaylistProvider({required this.id});

  PlaylistResponse? _playlistResponse;
  List<PlaylistResponse> _recoPlaylist = [];
  List<PlaylistResponse> _playlistTrending = [];
  List<SongResponse> _playlistSong = [];
  List<SongResponse> _trendingSong = [];
  List<Map<String, dynamic>> _trendingAlbum = [];
  bool _isLoading = false;


  PlaylistResponse? get playlistDetails => _playlistResponse;
  // List<Map<String , dynamic>> get recoPlaylist => _recoPlaylist;
  List<PlaylistResponse> get recoPlaylist => _recoPlaylist;
  List<PlaylistResponse> get playlistTrending => _playlistTrending;
  List<SongResponse> get playlistSong => _playlistSong;
  List<SongResponse> get trendingSong => _trendingSong;
  List<Map<String, dynamic>> get trendingAlbum => _trendingAlbum;

  bool get isLoading => _isLoading;

  Future<void> getPlaylistDetails(playlistId) async {

    _isLoading = true;
    notifyListeners();

    _playlistResponse = await jio.playlist.detailsById(playlistId);
    notifyListeners();

    List<String> ids = _playlistResponse!.songs!.map((e) => e.id).toList();
     _playlistSong = await jio.songs.detailsByIds(ids);
    notifyListeners();

    getReco(playlistId);
    notifyListeners();

    getTrending(playlistId);
    notifyListeners();

    _isLoading = false;
    notifyListeners();

  }

  Future<void> getReco(playlistId) async {
    _recoPlaylist = await jio.playlist.reco(playlistId);
  }

  Future<void> getTrending(playlistId) async {
    var trend = await jio.playlist.trending(playlistId);
    var playlist = trend.where((e)=>e['type']=='playlist').toList();
    _playlistTrending = playlist.map((e)=>PlaylistResponse.fromJson(e)).toList();
    _trendingAlbum = trend.where((e)=>e['type']=='album').toList();
    var songIds = trend
        .where((e) => e['type'] == 'song')
        .map((e) => e['details']['id'] as String)
        .toList();
    _trendingSong = await jio.songs.detailsByIds(songIds);
    notifyListeners();
  }

}

class PlayListResponse {
  PlaylistResponse playlist;
  List<SongResponse> song;

  PlayListResponse({required this.song, required this.playlist});
}