
import '../client.dart';
import '../collection/endpoints.dart';
import '../models/album.dart';

class AlbumEndpoint extends BaseClient {
  AlbumEndpoint([super.options]);

  Future<AlbumResponse> detailsById(String id) async {
    // api v4 does not contain media_preview_url
    final response = await request(call: endpoints.albums.id, queryParameters: {
      'albumid': id,
    });
    final albumResults =
        AlbumResponse.fromAlbumRequest(AlbumRequest.fromJson(response));

    return albumResults;
  }

  Future<List<AlbumResponse>> getReco(String id) async {
    // api v4 does not contain media_preview_url
    final response = await requestReco(
        call: endpoints.albums.reco,
        queryParameters: {
      'albumid': id,
    });
    List<Future<AlbumResponse>> data=[];
    List<String> recoAlbumId= response.map((e) => e['id'] as String).toList();
    recoAlbumId.forEach((element) {
      data.add(detailsById(element));
    });
    var recoAlbum = Future.wait(data.where((element) => element!=null));

    return recoAlbum;
  }


  Future<List<AlbumResponse>> trendingAlbum(String id) async {
    // api v4 does not contain media_preview_url
    final response = await requestReco(
        call: endpoints.albums.trendingAlbum,
        queryParameters: {
          'entity_type': 'album',
          'ctx': 'wap6dot0'
        });
    print(response);
    List<Future<AlbumResponse>> data=[];
    List<dynamic> recoAlbumId= response.map((e) => e['id'] as String).toList();
    recoAlbumId.forEach((element) {
      data.add(detailsById(element));
    });
    var recoAlbum = Future.wait(data.where((element) => element!=null));

    return recoAlbum;
  }

  Future<List<AlbumResponse>> topAlbumsOfTheYear(String year) async {
    // Make the API call to get trending albums of the year
    final response = await requestReco(
      call: endpoints.albums.trendingAlbum,
      queryParameters: {
        'album_year': year
      },
    );
    var data = response as List;
    List<Future<AlbumResponse>> albumFutures = data
        .map((e) => e['details']['albumid'])
        .where((albumId) => albumId != null)
        .map((albumId) => detailsById(albumId))
        .toList();
    return await Future.wait(albumFutures);
  }

}
