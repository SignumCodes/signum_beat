import 'package:json_annotation/json_annotation.dart';
import '../utils/link.dart';
import 'artist.dart';
import 'image.dart';
import 'song.dart';

part 'album.g.dart';

@JsonSerializable()
class AlbumSearchRequest {
  int total;
  int start;
  List<AlbumRequest> results;

  AlbumSearchRequest(
      {required this.total, required this.start, required this.results});

  factory AlbumSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$AlbumSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumSearchRequestToJson(this);
}

@JsonSerializable()
class Album {
  String? name;
  String year;

  @JsonKey(name: "release_date")
  String? releaseDate;

  @JsonKey(name: "primary_artists")
  String? primaryArtists;

  @JsonKey(name: "primary_artists_id")
  String? primaryArtistsId;

  @JsonKey(name: "featured_artists")
  String? featuredArtists;

  @JsonKey(name: "featured_artists_id")
  String? featuredArtistsId;

  @JsonKey(name: "albumid")
  String? albumId;

  @JsonKey(name: "perma_url")
  String permaUrl;
  String image;
  List<SongRequest>? songs;

  Album({
    this.name,
    required this.year,
    this.releaseDate,
    this.primaryArtists,
    this.primaryArtistsId,
    this.featuredArtists,
    this.featuredArtistsId,
    this.albumId,
    required this.permaUrl,
    required this.image,
    this.songs,
  });

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}

@JsonSerializable()
class AlbumRequest extends Album {
  String? id;
  String title;
  String? subtitle;

  @JsonKey(name: "header_desc")
  String? headerDesc;
  String? type;
  String? language;

  @JsonKey(name: "play_count")
  String? playCount;

  @JsonKey(name: "explicit_content")
  String? explicitContent;

  @JsonKey(name: "list_count")
  String? listCount;

  @JsonKey(name: "list_type")
  String? listType;
  String? list;

  @JsonKey(name: "more_info")
  MoreInfo? moreInfo;

  AlbumRequest({
    this.id,
    this.subtitle,
    this.moreInfo,
    required this.title,
    this.headerDesc,
    this.type,
    this.language,
    this.playCount,
    this.explicitContent,
    this.listCount,
    this.listType,
    this.list,
    // Properties from the parent class Album
    required super.name,
    required super.year,
    required super.releaseDate,
    required super.primaryArtists,
    required super.primaryArtistsId,
    required super.albumId,
    required super.permaUrl,
    required super.image,
    required super.songs,
  });

  factory AlbumRequest.fromJson(Map<String, dynamic> json) =>
      _$AlbumRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AlbumRequestToJson(this);
}

@JsonSerializable()
class AlbumSearchResponse {
  int total;
  int start;
  List<AlbumResponse> results;

  AlbumSearchResponse(
      {required this.total, required this.start, required this.results});

  factory AlbumSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$AlbumSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumSearchResponseToJson(this);
}

@JsonSerializable()
class AlbumResponse {
  String id;
  String name;
  String subTitle;
  String year;
  String? type;

  @JsonKey(name: "play_count")
  String? playCount;
  String? language;

  @JsonKey(name: "explicit_content")
  String? explicitContent;

  @JsonKey(name: "primary_artists_id")
  String? primaryArtistsId;

  @JsonKey(name: "primary_artists")
  String? primaryArtists;
  List<AlbumArtistResponse> artists;

  @JsonKey(name: "featured_artists")
  String? featuredArtists;

  @JsonKey(name: "featured_artists_id")
  String? featuredArtistsId;

  @JsonKey(name: "song_count")
  String songCount;

  @JsonKey(name: "release_date")
  String? releaseDate;

  List<DownloadLink>? image;
  String url;
  List<SongResponse> songs;

  AlbumResponse({
    required this.id,
    required this.name,
    required this.subTitle,
    required this.year,
    this.type,
    this.playCount,
    this.language,
    this.explicitContent,
    this.primaryArtistsId,
    required this.primaryArtists,
    required this.artists,
    this.featuredArtists,
    this.featuredArtistsId,
    required this.songCount,
    this.releaseDate,
    this.image,
    required this.url,
    required this.songs,
  });

  factory AlbumResponse.fromAlbumRequest(AlbumRequest album) {
    return AlbumResponse(
      id: (album.albumId ?? album.id) as String,
      name: album.title,
      subTitle: album.subtitle??'',
      year: album.year,
      type: album.type,
      releaseDate: album.releaseDate,
      playCount: album.playCount,
      language: album.language,
      explicitContent: album.explicitContent,
      songCount:
          album.moreInfo?.songCount ?? album.songs?.length.toString() ?? '0',
      url: album.permaUrl,
      primaryArtistsId: album.primaryArtistsId,
      primaryArtists: album.primaryArtists,
      featuredArtists: album.featuredArtists,
      artists: album.moreInfo?.artistMap?.artists
              ?.map(
                (artist) => AlbumArtistResponse.fromArtist(artist),
              )
              .toList() ??
          [],
      image: createImageLinks(album.image),
      songs: [
        if (album.songs != null)
          for (final song in album.songs!) SongResponse.fromSongRequest(song),
      ],
    );
  }

  factory AlbumResponse.fromJson(Map<String, dynamic> json) =>
      _$AlbumResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumResponseToJson(this);
}

@JsonSerializable()
class AlbumArtistResponse {
  String id;
  String name;
  String? role;
  List<DownloadLink>? image;
  String type;
  String? url;

  AlbumArtistResponse({
    required this.id,
    required this.name,
    this.role,
    this.image,
    required this.type,
    this.url,
  });

  factory AlbumArtistResponse.fromArtist(Artist artist) {
    return AlbumArtistResponse(
      id: artist.id!,
      name: artist.name,
      url: artist.permaUrl,
      type: artist.type,
      role: artist.role,
      image: createImageLinks(artist.image),
    );
  }

  factory AlbumArtistResponse.fromJson(Map<String, dynamic> json) =>
      _$AlbumArtistResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumArtistResponseToJson(this);
}

@JsonSerializable()
class ArtistMap {
  @JsonKey(name: "primary_artists")
  List<Artist>? primaryArtists;

  @JsonKey(name: "featured_artists")
  List<Artist>? featuredArtists;

  List<Artist>? artists;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? map;

  ArtistMap({
    this.primaryArtists,
    this.featuredArtists,
    this.artists,
    this.map,
  });

  factory ArtistMap.fromJson(Map<String, dynamic> json) => [
        "primary_artists",
        "featured_artists",
        "artists"
      ].every((key) => json[key] == null)
          ? ArtistMap(map: json)
          : _$ArtistMapFromJson(json);

  Map<String, dynamic> toJson() => map != null ? map! : _$ArtistMapToJson(this);
}

@JsonSerializable()
class MoreInfo {
  String query;
  String text;
  String? music;

  @JsonKey(name: "song_count")
  String songCount;

  @JsonKey(name: "artist_map")
  ArtistMap? artistMap;

  MoreInfo({
    required this.query,
    required this.text,
    this.music,
    required this.songCount,
    this.artistMap,
  });

  factory MoreInfo.fromJson(Map<String, dynamic> json) =>
      _$MoreInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MoreInfoToJson(this);
}
