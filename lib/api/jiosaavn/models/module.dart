import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

@JsonSerializable()
class ModuleResponse {
  List<dynamic> ?radio;
  List<dynamic>? browseDiscover;
  List<dynamic>? newAlbums;
  List<dynamic> ?charts;
  Map<String,dynamic>? global_config;
  List<dynamic>? newTrending;
  List<dynamic>? topPlaylists;
  List<dynamic>? artist_recos;
  List<dynamic>? tagMixes;


  ModuleResponse({
     this.radio,
     this.browseDiscover,
     this.newAlbums,
     this.charts,
     this.global_config,
     this.newTrending,
     this.topPlaylists,
    this.artist_recos,
    this.tagMixes
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) =>
      _$ModulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleResponseToJson(this);
}

@JsonSerializable()
class GlobalConfig{
  RandomSongList?  random_songs_listid;
  RandomSongList?  weekly_top_songs_listid;

  GlobalConfig({
    this.random_songs_listid,
    this.weekly_top_songs_listid
  });
  factory GlobalConfig.fromJson(Map<String, dynamic> json) =>
      _$GlobalConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalConfigToJson(this);
}

@JsonSerializable()
class RandomSongList{
  String? listId;
  String? image;
  RandomSongList({
    this.listId,
    this.image
});


  factory RandomSongList.fromJson(Map<String, dynamic> json) =>
      _$RandomSongListFromJson(json);

  Map<String, dynamic> toJson() => _$RandomSongListToJson(this);
}



/*@JsonSerializable()
class MoreInfo {
  String badge;
  String subType;
  String available;
  String isFeatured;
  Map<String, dynamic> tags;
  String videoUrl;
  String videoThumbnail;

  MoreInfo({
    required this.badge,
    required this.subType,
    required this.available,
    required this.isFeatured,
    required this.tags,
    required this.videoUrl,
    required this.videoThumbnail,
  });

  factory MoreInfo.fromJson(Map<String, dynamic> json) =>
      _$MoreInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MoreInfoToJson(this);
}*/

/*
@JsonSerializable()
class TopShows {
  String badge;
  List<Map<String, dynamic>> shows;
  bool lastPage;

  TopShows({
    required this.badge,
    required this.shows,
    required this.lastPage,
  });

  factory TopShows.fromJson(Map<String, dynamic> json) =>
      _$TopShowsFromJson(json);

  Map<String, dynamic> toJson() => _$TopShowsToJson(this);
}

@JsonSerializable()
class NewTrending {
  String id;
  String title;
  String subtitle;
  String headerDesc;
  String type;
  String permaUrl;
  String image;
  String language;
  String year;
  String playCount;
  String explicitContent;
  String listCount;
  String listType;
  String list;
  MoreInfo moreInfo;

  NewTrending({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.headerDesc,
    required this.type,
    required this.permaUrl,
    required this.image,
    required this.language,
    required this.year,
    required this.playCount,
    required this.explicitContent,
    required this.listCount,
    required this.listType,
    required this.list,
    required this.moreInfo,
  });

  factory NewTrending.fromJson(Map<String, dynamic> json) =>
      _$NewTrendingFromJson(json);

  Map<String, dynamic> toJson() => _$NewTrendingToJson(this);
}

@JsonSerializable()
class ModulesResponse {
  List<AlbumResponse> albums;
  List<ChartResponse> charts;
  TrendingResponse trending;
  List<PlaylistResponse> playlists;

  ModulesResponse({
    required this.albums,
    required this.charts,
    required this.trending,
    required this.playlists,
  });

  factory ModulesResponse.fromJson(Map<String, dynamic> json) =>
      _$ModulesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModulesResponseToJson(this);
}

@JsonSerializable()
class ChartResponse {
  String id;
  String title;
  String subtitle;
  String type;
  DownloadLink image;
  String url;
  String firstname;
  String explicitContent;
  String language;

  ChartResponse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.image,
    required this.url,
    required this.firstname,
    required this.explicitContent,
    required this.language,
  });

  factory ChartResponse.fromJson(Map<String, dynamic> json) =>
      _$ChartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChartResponseToJson(this);
}

@JsonSerializable()
class TrendingResponse {
  List<Omit<SongResponse, String>> songs;
  List<Omit<AlbumResponse, String>> albums;

  TrendingResponse({
    required this.songs,
    required this.albums,
  });

  factory TrendingResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingResponseToJson(this);
}


*/
