import 'package:flutter/material.dart';
import '../api/jiosaavn/jiosaavn.dart';
import '../api/jiosaavn/models/album.dart';
import '../api/jiosaavn/models/artist.dart';
import '../api/jiosaavn/models/playlist.dart';
import '../api/jiosaavn/models/search.dart';
import '../api/jiosaavn/models/song.dart';

class SearchMusicProvider with ChangeNotifier {
  final JioSaavnClient jio = JioSaavnClient();

  List<SongResponse> _autoCompleteSongs = [];
  List<PlaylistResponse> _autoCompletePlaylist = [];
  List<SongResponse> _searchSongs = [];
  List<AllSearchResponse> _autoComplete = [];
  List<PlaylistResponse> _searchPlaylist = [];
  List<ArtistResponse> _searchArtist = [];
  List<AlbumResponse> _searchAlbum = [];
  List<TopSearchResponse> _topSearchResponse = [];
  TextEditingController searchTextController = TextEditingController();

  // Getters
  List<SongResponse> get autoCompleteSongs => _autoCompleteSongs;
  List<PlaylistResponse> get autoCompletePlaylist => _autoCompletePlaylist;
  List<SongResponse> get searchSongs => _searchSongs;
  List<AllSearchResponse> get autoComplete => _autoComplete;
  List<PlaylistResponse> get searchPlaylist => _searchPlaylist;
  List<ArtistResponse> get searchArtist => _searchArtist;
  List<AlbumResponse> get searchAlbum => _searchAlbum;
  List<TopSearchResponse> get topSearchResponse => _topSearchResponse;


  Future<void> getSearchModule(String query) async {
    try {
      var all = await jio.search.all(query);

      _autoComplete.clear();
      _autoComplete.add(all);

      // Autocomplete songs
      List<String> songIds = all.songs.results.map((e) => e.id).toList();
      var song = await jio.songs.detailsByIds(songIds);
      _autoCompleteSongs.clear();
      _autoCompleteSongs.addAll(song);

      // Autocomplete playlists
      var playListIds = all.playlists.results.map((e) => e.id).toList();
      var playlist = await Future.wait(
        playListIds.map((e) async => await jio.playlist.detailsById(e)).toList(),
      );

      
      _autoCompletePlaylist.clear();
      _autoCompletePlaylist.addAll(playlist);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  /*Future<void> searchResult(String query) async {
    try {
      var song = await jio.search.songs(query, page: 1);
      var album = await jio.search.albums(query, page: 1);
      var play = await jio.search.playlist(query, page: 1);

      var playlist = await Future.wait(
        play.results.map((e) async => await jio.playlist.detailsById(e.id.toString())).toList(),
      );

      var artist = await jio.search.artists(query, page: 1);
      var ids = song.results.map((e) => e.id).toList();
      var songs = await jio.songs.detailsByIds(ids);

      _searchSongs.clear();
      _searchSongs.addAll(songs);

      _searchPlaylist.clear();
      _searchPlaylist.addAll(playlist);

      _searchAlbum.clear();
      _searchAlbum.addAll(album.results);

      _searchArtist.clear();
      _searchArtist.addAll(artist.results);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }*/

  Future<void> getTopSearch()async{
    _topSearchResponse  = await jio.search.topSearch();
    notifyListeners();
  }


}
