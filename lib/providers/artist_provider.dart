import 'package:flutter/cupertino.dart';

import '../api/jiosaavn/jiosaavn.dart';
import '../api/jiosaavn/models/playlist.dart';
import '../api/jiosaavn/models/song.dart';

class ArtistProvider extends ChangeNotifier {

  final JioSaavnClient jio = JioSaavnClient();

  Map<String, dynamic> _artistDetail = <String, dynamic>{};
  List<PlaylistResponse> _dedicatedArtistPlaylists = [];
  List<dynamic> _featuredArtistPlaylist = [];
  List<dynamic> _latestReleaseAlbum = [];
  List<dynamic> _topAlbums = [];
  List<dynamic> _singleAlbums = [];
  List<dynamic> _latestAlbums = [];
  List<SongResponse> _topSongs = [];
  bool _isLoading = false;

  // Getters for each property
  Map<String, dynamic> get artistDetail => _artistDetail;
  List<PlaylistResponse> get dedicatedArtistPlaylists => _dedicatedArtistPlaylists;
  List<dynamic> get featuredArtistPlaylist => _featuredArtistPlaylist;
  List<dynamic> get latestReleaseAlbum => _latestReleaseAlbum;
  List<dynamic> get topAlbums => _topAlbums;
  List<dynamic> get singleAlbums => _singleAlbums;
  List<dynamic> get latestAlbums => _latestAlbums;
  List<SongResponse> get topSongs => _topSongs;
  bool get isLoading => _isLoading;


  // Method to fetch and update artist details
  Future<void> getArtistDetails(String artistId) async {
    _isLoading = true;
    try {
      Map<String, dynamic> artistMap = await jio.artists.detailById(artistId);
      _artistDetail = artistMap;
      _isLoading = false;
      // Fetch and update top songs
      var songs = artistMap['topSongs'] as List<dynamic>;
      List<String> ids = songs.map((e) => e['id'] as String).toList();
      _topSongs = await jio.songs.detailsByIds(ids);

      // Fetch and update dedicated artist playlists
      _dedicatedArtistPlaylists = await Future.wait(
        (artistMap['dedicated_artist_playlist'] as List<dynamic>)
            .map((e) async => await jio.playlist.detailsById(e['id'])),
      );

      // Fetch and update other properties
      _featuredArtistPlaylist = artistMap['featured_artist_playlist'] as List<dynamic>;
      _latestReleaseAlbum = artistMap['latest_release'] as List<dynamic>;
      _topAlbums = artistMap['topAlbums'] as List<dynamic>;
      _singleAlbums = (artistMap['singles'] as List<dynamic>).where((e)=>e['type'] == 'album' ).toList();
      _latestAlbums = (artistMap['singles'] as List<dynamic>).where((e)=>e['type'] == 'album' ).toList();

      notifyListeners(); // Notify listeners after updating all properties
    } catch (e) {
      print("Error fetching artist details: $e");
    }
  }
}
