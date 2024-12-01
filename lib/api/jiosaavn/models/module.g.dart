part of 'module.dart';

ModuleResponse _$ModulesResponseFromJson(Map<String, dynamic> json) {
  return ModuleResponse(
    radio: (json['radio'] as List<dynamic>),
    browseDiscover: (json['browse_discover'] as List<dynamic>),
    newAlbums: (json['new_albums'] as List<dynamic>),
    charts: (json['charts'] as List<dynamic>),
    global_config: (json['global_config']),
    newTrending: (json['new_trending'] as List<dynamic>),
    topPlaylists: (json['top_playlists'] as List<dynamic>),
      tagMixes: (json['tag_mixes'] as List<dynamic>)
  );
}
Map<String, dynamic> _$ModuleResponseToJson(ModuleResponse instance) {
  return <String, dynamic>{
    'radio': instance.radio,
    'browseDiscover': instance.browseDiscover,
    'newAlbums': instance.newAlbums,
    'charts': instance.charts,
    'global_config': instance.global_config,
    'newTrending': instance.newTrending,
    'topPlaylists': instance.topPlaylists,
    'artist_recos':instance.artist_recos
  };
}

GlobalConfig _$GlobalConfigFromJson(Map<String, dynamic> json){
  return GlobalConfig(
    random_songs_listid:json['random_songs_listid'] as RandomSongList,
    weekly_top_songs_listid: json['weekly_top_songs_listid'] as RandomSongList,
  );
}
Map<String, dynamic> _$GlobalConfigToJson(GlobalConfig instance) {
  return {
    'random_songs_listid': instance.random_songs_listid,
    'weekly_top_songs_listid': instance.weekly_top_songs_listid,
  };
}

RandomSongList _$RandomSongListFromJson(Map<String, dynamic> json){
  return RandomSongList(
    listId:json['hindi']['listid'],
    image: json['hindi']['image'],
  );
}
Map<String, dynamic> _$RandomSongListToJson(RandomSongList instance) {
  return {
    'listid': instance.listId,
    'image': instance.image,
  };
}

