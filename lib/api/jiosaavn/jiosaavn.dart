import 'package:dio/dio.dart';
import 'endpoints/album.dart';
import 'endpoints/artist.dart';
import 'endpoints/lyrics.dart';
import 'endpoints/module.dart';
import 'endpoints/playlist.dart';
import 'endpoints/search.dart';
import 'endpoints/song.dart';

class JioSaavnClient {
  final AlbumEndpoint albums;
  final ArtistEndpoint artists;
  final SongEndpoint songs;
  final SearchEndpoint search;
  final PlaylistEndpont playlist;
  final ModuleEndpoint module;
  final LyricsEndpoint lyrics;

  JioSaavnClient([BaseOptions? options])
      : albums = AlbumEndpoint(options),
        artists = ArtistEndpoint(options),
        songs = SongEndpoint(options),
        search = SearchEndpoint(options),
        playlist=PlaylistEndpont(options),
        module=ModuleEndpoint(options),
        lyrics = LyricsEndpoint(options);
}
