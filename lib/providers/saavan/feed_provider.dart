import 'package:flutter/material.dart';
import '../../api/jiosaavn/jiosaavn.dart';
import '../../api/jiosaavn/models/module.dart';
import '../../api/jiosaavn/models/playlist.dart';
import '../../api/jiosaavn/models/song.dart';

class FeedProvider with ChangeNotifier {
  final JioSaavnClient jio = JioSaavnClient();

  ModuleResponse _module = ModuleResponse();
  List<dynamic> _recoArtist =[];

  ModuleResponse get module => _module;
  List<dynamic> get recoArist=> _recoArtist;

  bool _isLoading = false;
  bool _hasLoaded = false;

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;

  Future<void> loadModules() async {
    if (_hasLoaded) return;

    _isLoading = true;
    notifyListeners();


    try {
      _module = await jio.module.getModules();
      _recoArtist = await jio.module.getArtist()??[];
      _hasLoaded = true;
    } catch (e,st) {
      print('Error loading modules: $e');
      print('Error loading modules: $st');

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<List<SongResponse>> weeklyTopSongList() async {
    try {
      var module = await jio.module.getGlobalConfig();
      var weeklyTopSongsListId = module?['weekly_top_songs_listid']['hindi']['listid'];
      PlaylistResponse playlist = await jio.playlist.detailsById(weeklyTopSongsListId);
      var ids = playlist.songs?.map((e) => e.id).toList();
      var songs = await jio.songs.detailsByIds(ids!);
      return songs;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
