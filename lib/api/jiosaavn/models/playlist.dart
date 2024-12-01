import 'package:json_annotation/json_annotation.dart';
import 'image.dart';
import 'song.dart';
part 'playlist.g.dart';

@JsonSerializable()
class PlaylistSearchRequest {
  PlaylistSearchRequest({
    required this.total,
    required this.start,
    required this.results,
  });

  final int total;
  final int start;
  final List<PlaylistRequest> results;

  factory PlaylistSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaylistSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistSearchRequestToJson(this);
}

@JsonSerializable()
class PlaylistRequest extends Playlist {
  PlaylistRequest({
     this.artistName,
    required this.count,
    required this.language,
    required this.entityType,
    this.entitySubType='',
    required this.numsongs,
    super.artists,
    required super.id,
    required super.listname,
    required super.permaUrl,
    super.followerCount,
    required super.uid,
    super.lastUpdated,
    required super.username,
    required super.firstname,
    required super.lastname,
    super.isFollowed,
    super.isFY,
    required super.image,
     super.share,
     super.songs,
     super.type,
     super.listCount,
     super.fanCount,
     super.h2,
     super.isDolbyPlaylist,
     super.subheading,
     super.subTypes,
     super.images,
     super.videoAvailable,
     super.videoCount,
  });

  @JsonKey(name: 'artist_name')
  final List<String>? artistName;

  @JsonKey(name: 'count')
  final String count;

  @JsonKey(name: 'language')
  final String language;

  @JsonKey(name: 'entity_type')
  final String ? entityType;

  @JsonKey(name: 'entity_sub_type')
  final String entitySubType;

  @JsonKey(name: 'numsongs')
  final dynamic numsongs;

  factory PlaylistRequest.fromJson(Map<String, dynamic> json) =>
      _$PlaylistRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaylistRequestToJson(this);
}

@JsonSerializable()
class PlaylistSearchResponse {
  PlaylistSearchResponse({
    required this.total,
    required this.start,
    required this.results,
  });

  final int total;
  final int start;
  final List<PlaylistResponse> results;

  factory PlaylistSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaylistSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistSearchResponseToJson(this);
}

@JsonSerializable()
class PlaylistResponse {
  PlaylistResponse({
     this.id,
     this.userId,
     this.name,
     this.songCount,
     this.fanCount,
     this.followerCount,
     this.username,
     this.firstname,
     this.language,
     this.lastname,
     this.shares,
     this.image,
     this.images,
     this.url,
     this.songs,
  });

  final String? id;
  final String? userId;
  final String? name;

  @JsonKey(name: 'song_count')
  final String? songCount;

  @JsonKey(name: 'fan_count')
  final String? fanCount;

  @JsonKey(name: 'follower_count')
  final String? followerCount;

  final String? username;
  final String? firstname;
  final String? language;
  final String? lastname;
  final String? shares;
  final dynamic image;
  final List<DownloadLink>? images;
  final String? url;
  final List<PlaylistSongResponse>? songs;

  factory PlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaylistResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistResponseToJson(this);
}

@JsonSerializable()
class Playlist {
  Playlist({
     this.artists,
     this.id,
     this.listname,
     this.permaUrl,
     this.followerCount,
     this.uid,
     this.lastUpdated,
     this.username,
     this.firstname,
     this.lastname,
     this.isFollowed,
     this.isFY,
     this.image,
     this.share,
     this.songs,
     this.type,
     this.listCount,
     this.fanCount,
     this.h2,
     this.isDolbyPlaylist,
     this.subheading,
     this.subTypes,
     this.images,
     this.videoAvailable,
     this.videoCount,
  });

  final List<dynamic>? artists;

  @JsonKey(name: 'listid')
  final String? id;

  @JsonKey(name: 'listname')
  final String? listname;

  @JsonKey(name: 'perma_url')
  final String? permaUrl;

  @JsonKey(name: 'follower_count')
  final String? followerCount;

  final String? uid;

  @JsonKey(name: 'last_updated')
  final String? lastUpdated;

  final String? username;
  final String? firstname;
  final String? lastname;

  @JsonKey(name: 'is_followed')
  final String? isFollowed;

  @JsonKey(name: 'isFY')
  final bool? isFY;

  final String? image;
  final String? share;
  final List<SongRequest>? songs;
  final String? type;

  @JsonKey(name: 'list_count')
  final String? listCount;

  @JsonKey(name: 'fan_count')
  final int? fanCount;

  @JsonKey(name: 'H2')
  final dynamic h2;

  @JsonKey(name: 'is_dolby_playlist')
  final bool? isDolbyPlaylist;

  final dynamic subheading;

  @JsonKey(name: 'sub_types')
  final List<dynamic>? subTypes;

  final List<dynamic>? images;

  @JsonKey(name: 'video_available')
  final bool ?videoAvailable;

  @JsonKey(name: 'video_count')
  final int? videoCount;

  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistToJson(this);


}
