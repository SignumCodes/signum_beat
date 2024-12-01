  import '../client.dart';
import '../collection/endpoints.dart';
import '../models/module.dart';

class ModuleEndpoint extends BaseClient {
  ModuleEndpoint([super.options]);

  // final jio = JioSaavnClient();

  Future<ModuleResponse> getModules() async {
    final response = await request(call: endpoints.module.link);
    final module = ModuleResponse.fromJson(response);
    return module;
  }
  Future<List?> getChart() async {
    var module= await getModules();
    var chart= module.charts;
    return chart;
  }

  Future<List?> getArtist()async {
    final response= await request(call: endpoints.module.artistRecos);
    final artist = response['top_artists'];
    return artist as List<dynamic>;
  }

  Future<List> getNewAlbumId()async {
    final response= await request(call: endpoints.module.newAlbums);
    // final tags= await request(call: endpoints.module.tagMixes);
    // print(tags);
    final artist = response['data'] as List<dynamic>;
    artist.map((e) => e['albumid']).toList();

    return artist.map((e) => e['albumid']).toList(); //as List<dynamic>;
  }

  Future<Map<String, dynamic>?> getGlobalConfig() async {
    var module= await getModules();
    var global= await module.global_config;
    // print(global);
    return global;
  }

  Future<List?> getTopPlaylist() async {
    var module= await getModules();
    var topPlaylist= module.topPlaylists;
    // print(module.tagMixes);
    var ids=topPlaylist?.map((e) =>e['listid'] ).toList();
    return ids;
  }

}