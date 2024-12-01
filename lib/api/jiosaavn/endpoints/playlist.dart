import '../client.dart';
import '../collection/endpoints.dart';
import '../models/playlist.dart';

class PlaylistEndpont extends BaseClient {
  PlaylistEndpont([super.options]);

  Future<PlaylistResponse> detailsById(String id) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.playlists.id, queryParameters: {
      'listid': id,
    });
    final playlistresult = PlaylistResponse.fromJson(response);


    return playlistresult;
  }

  Future<List<PlaylistResponse>> reco(String id) async {
    final response = await requestReco(call: endpoints.playlists.reco, queryParameters: {
      'listid': id,
    });
    return response
        .map((item) => PlaylistResponse.fromJson(item) )
        .toList();
  }
  Future<List<Map<String ,dynamic>>> trending(String id) async {
    final response = await requestReco(call: endpoints.playlists.trending, queryParameters: {
      'listid': id,
    });
    return response
        .map((item) =>item as Map<String ,dynamic> )
        .toList();
  }
}