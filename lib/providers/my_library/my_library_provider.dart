/*
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';

class MediaStoreProvider extends ChangeNotifier {
  final MediaStore _mediaStore = MediaStore();
  List<MediaFile> _audioFiles = [];
  List<Playlist> _playlists = [];
  List<Album> _albums = [];
  List<Artist> _artists = [];
  bool _isLoading = true;

  List<MediaFile> get audioFiles => _audioFiles;
  List<Playlist> get playlists => _playlists;
  List<Album> get albums => _albums;
  List<Artist> get artists => _artists;
  bool get isLoading => _isLoading;

  MediaStoreProvider() {
    fetchMedia();
  }

  Future<void> fetchMedia() async {
    try {
      _isLoading = true;
      notifyListeners();

      _audioFiles = await _mediaStore..queryAudioFiles();
      _playlists = await _mediaStore.queryPlaylists();
      _albums = await _mediaStore.queryAlbums();
      _artists = await _mediaStore.queryArtists();
    } catch (e) {
      print('Error fetching media: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
*/
