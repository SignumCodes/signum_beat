import 'dart:convert';

import '../client.dart';
import '../collection/endpoints.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/search.dart';
import '../models/song.dart';

class SearchEndpoint extends BaseClient {
  SearchEndpoint([super.options]);

  Future<AllSearchResponse> all(String query) async {
    // api v4 doest not provide positions
    final result = await request(
      call: endpoints.search.all,
      queryParameters: {"query": query},
    );

    return AllSearchResponse.fromCustomJson(result);
  }

  Future<SongSearchResponse> songs(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    // api v4 does not contain media_preview_url
    final response = await request(
      call: endpoints.search.songs,
      queryParameters: {
        "q": query,
        "p": page,
        "n": limit,
      },
    );

    final req = SongSearchRequest.fromJson(response);

    return SongSearchResponse(
      results: req.results.map((e) => SongResponse.fromSongRequest(e)).toList(),
      start: req.start,
      total: req.total,
    );
  }

  Future<AlbumSearchResponse> albums(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    // api v4 does not contain media_preview_url
    final response = await request(
      call: endpoints.search.albums,
      queryParameters: {
        "q": query,
        "p": page,
        "n": limit,
      },
    );

    final req = AlbumSearchRequest.fromJson(response);

    return AlbumSearchResponse(
      results:
          req.results.map((e) => AlbumResponse.fromAlbumRequest(e)).toList(),
      start: req.start,
      total: req.total,
    );
  }

  Future<ArtistSearchResponse> artists(
    String query, {
    int page = 0,
    int limit = 10,
  }) async {
    // api v4 does not contain media_preview_url
    final response = await request(
      call: endpoints.search.artists,
      queryParameters: {
        "q": query,
        "p": page,
        "n": limit,
      },
    );

    final req = ArtistSearchRequest.fromJson(response);

    return ArtistSearchResponse(
      results:
          req.results.map((e) => ArtistResponse.fromArtistRequest(e)).toList(),
      start: req.start,
      total: req.total,
    );
  }

  Future<PlaylistSearchRequest> playlist(
      String query, {
        int page = 0,
        int limit = 10,
      }) async {
    // api v4 does not contain media_preview_url
    final response = await request(
      call: endpoints.search.playlists,
      queryParameters: {
        "q": query,
        "p": page,
        "n": limit,
      },
    );
    final req = PlaylistSearchRequest.fromJson(response);
    return req;
  }

  Future<List<TopSearchResponse>> topSearch() async {
    try {
      // Fetch data from the API
      final result = await requestReco(
        call: endpoints.search.topSearch,
      );
        return result.map((e)=>TopSearchResponse.fromJson(e)).toList();
    } catch (e) {
      // Handle and log errors
      throw Exception('Failed to fetch top search results: $e');
    }
  }


}
