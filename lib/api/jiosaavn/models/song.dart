import 'package:json_annotation/json_annotation.dart';

import '../utils/link.dart';
import 'album.dart';
import 'image.dart';

part 'song.g.dart'; // Make sure to replace 'song_interface' with your actual file name.

@JsonSerializable()
class SongSearchRequest {
  int total;
  int start;
  List<SongRequest> results;

  SongSearchRequest(
      {required this.total, required this.start, required this.results});

  factory SongSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$SongSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SongSearchRequestToJson(this);
}

@JsonSerializable()
class SongRequest {
  String id;
  String type;
  String song;
  String album;
  String year;
  String music;

  @JsonKey(name: "music_id")
  String musicId;

  @JsonKey(name: "primary_artists")
  String primaryArtists;

  @JsonKey(name: "primary_artists_id")
  String primaryArtistsId;

  @JsonKey(name: "featured_artists")
  String featuredArtists;

  @JsonKey(name: "featured_artists_id")
  String featuredArtistsId;
  String singers;
  String? starring;
  String image;
  String label;

  @JsonKey(name: "albumid")
  String albumId;
  String language;
  String origin;

  @JsonKey(name: "play_count", fromJson: SongRequest._toString)
  String? playCount;

  @JsonKey(name: "copyright_text")
  String copyrightText;

  @JsonKey(name: "320kbps")
  String kbps320;

  @JsonKey(name: "is_dolby_content")
  bool isDolbyContent;

  @JsonKey(name: "explicit_content")
  int explicitContent;

  @JsonKey(name: "has_lyrics")
  String hasLyrics;

  @JsonKey(name: "lyrics_snippet")
  String lyricsSnippet;

  @JsonKey(name: "encrypted_media_url")
  String encryptedMediaUrl;

  static bool _fromBoolOrString(Object? value) {
    if (value is bool) {
      return value;
    }
    return bool.parse(value as String);
  }

  static String? _toString(obj) => obj?.toString();

  @JsonKey(
    name: "encrypted_media_path",
    fromJson: SongRequest._toString,
  )
  String? encryptedMediaPath;

  @JsonKey(name: "media_preview_url")
  String? mediaPreviewUrl;

  @JsonKey(name: "perma_url")
  String permaUrl;

  @JsonKey(name: "album_url")
  String albumUrl;
  String duration;
  ArtistMap artistMap; // exclusion for snake_case
  Rights rights;
  bool? webp;

  @JsonKey(name: "cache_state")
  String? cacheState;
  String starred;

  @JsonKey(name: "release_date")
  // don't know about the actual type it is almost always null
  dynamic releaseDate;
  String? vcode;
  String? vlink;

  @JsonKey(name: "triller_available")
  bool trillerAvailable;

  @JsonKey(name: "label_url")
  String labelUrl;

  SongRequest({
    required this.id,
    required this.type,
    required this.song,
    required this.album,
    required this.year,
    required this.music,
    required this.musicId,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.singers,
    this.starring,
    required this.image,
    required this.label,
    required this.albumId,
    required this.language,
    required this.origin,
    this.playCount,
    required this.copyrightText,
    required this.kbps320,
    required this.isDolbyContent,
    required this.explicitContent,
    required this.hasLyrics,
    required this.lyricsSnippet,
    required this.encryptedMediaUrl,
    required this.encryptedMediaPath,
    this.mediaPreviewUrl,
    required this.permaUrl,
    required this.albumUrl,
    required this.duration,
    required this.artistMap,
    required this.rights,
    this.webp,
    this.cacheState,
    required this.starred,
    required this.releaseDate,
    this.vcode,
    this.vlink,
    required this.trillerAvailable,
    required this.labelUrl,
  });

  factory SongRequest.fromArtistTopSong(Map<String, dynamic> json) {
    final moreInfo = json["more_info"];

    final artistMap = ArtistMap.fromJson(moreInfo["artistMap"]);
    return SongRequest(
      id: json["id"],
      album: moreInfo["album"],
      albumId: moreInfo["album_id"],
      albumUrl: moreInfo["album_url"],
      artistMap: artistMap,
      copyrightText: moreInfo["copyright_text"],
      duration: moreInfo["duration"],
      encryptedMediaPath: json["encrypted_media_path"]?.toString(),
      encryptedMediaUrl: moreInfo["encrypted_media_url"],
      explicitContent: int.parse(json["explicit_content"]),
      featuredArtists:
          artistMap.featuredArtists!.map((artist) => artist.name).join(", "),
      featuredArtistsId:
          artistMap.featuredArtists!.map((artist) => artist.id).join(", "),
      hasLyrics: moreInfo["has_lyrics"],
      image: json["image"],
      isDolbyContent: moreInfo["is_dolby_content"],
      kbps320: moreInfo["320kbps"],
      label: moreInfo["label"],
      labelUrl: moreInfo["label_url"],
      language: json["language"],
      lyricsSnippet: moreInfo["lyrics_snippet"],
      music: moreInfo["music"],
      musicId: json["id"],
      origin: moreInfo["origin"],
      permaUrl: json["perma_url"],
      playCount: json["play_count"],
      primaryArtists:
          artistMap.primaryArtists!.map((artist) => artist.name).join(", "),
      primaryArtistsId:
          artistMap.primaryArtists!.map((artist) => artist.id).join(", "),
      releaseDate: moreInfo["release_date"],
      rights: Rights.fromJson(moreInfo["rights"]),
      singers: artistMap.artists!.map((artist) => artist.name).join(", "),
      song: json["title"],
      starred: moreInfo["starred"],
      starring: moreInfo["starring"],
      trillerAvailable: moreInfo["triller_available"],
      type: json["type"] as String,
      year: json["year"] as String,
      cacheState: moreInfo["cache_state"] as String?,
      mediaPreviewUrl: "",
      vcode: moreInfo["vcode"] as String?,
      vlink: moreInfo["vlink"] as String?,
      // webp: bool.parse(moreInfo["webp"] as String),
    );
  }

  factory SongRequest.fromJson(Map<String, dynamic> json) =>
      _$SongRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SongRequestToJson(this);
}

@JsonSerializable()
class Rights {
  static int _fromIntOrString(Object? value) {
    if (value is int) {
      return value;
    }
    return int.parse(value as String);
  }

  @JsonKey(fromJson: Rights._fromIntOrString)
  int code;
  String reason;

  @JsonKey(fromJson: SongRequest._fromBoolOrString)
  bool cacheable;

  @JsonKey(
    name: "delete_cached_object",
    fromJson: SongRequest._fromBoolOrString,
  )
  bool deleteCachedObject;

  Rights({
    required this.code,
    required this.reason,
    required this.cacheable,
    required this.deleteCachedObject,
  });

  factory Rights.fromJson(Map<String, dynamic> json) => _$RightsFromJson(json);

  Map<String, dynamic> toJson() => _$RightsToJson(this);
}

@JsonSerializable()
class SongSearchResponse {
  int total;
  int start;
  List<SongResponse> results;

  SongSearchResponse(
      {required this.total, required this.start, required this.results});

  factory SongSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SongSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SongSearchResponseToJson(this);
}

@JsonSerializable()
class SongResponse {
  String id;
  String? name;
  String type;
  SongResponseAlbum album;
  String year;
  String? mediaPreview;

  @JsonKey(name: "release_date")
  String releaseDate;
  String duration;
  String label;

  @JsonKey(name: "primary_artists")
  String primaryArtists;

  @JsonKey(name: "primary_artists_id")
  String primaryArtistsId;

  @JsonKey(name: "featured_artists")
  String featuredArtists;

  @JsonKey(name: "featured_artists_id")
  String featuredArtistsId;

  @JsonKey(name: "explicit_content")
  int explicitContent;

  @JsonKey(name: "play_count")
  String? playCount;
  String language;

  @JsonKey(name: "has_lyrics")
  String hasLyrics;
  String url;
  String copyright;
  List<DownloadLink>? image;

  @JsonKey(name: "download_links")
  List<DownloadLink>? downloadUrl;

  SongResponse({
    required this.id,
    this.name,
    this.mediaPreview,
    required this.type,
    required this.album,
    required this.year,
    required this.releaseDate,
    required this.duration,
    required this.label,
    required this.primaryArtists,
    required this.primaryArtistsId,
    required this.featuredArtists,
    required this.featuredArtistsId,
    required this.explicitContent,
    this.playCount,
    required this.language,
    required this.hasLyrics,
    required this.url,
    required this.copyright,
    this.image,
    this.downloadUrl,
  });

  factory SongResponse.fromSongRequest(SongRequest song) {
    return SongResponse(
      id: song.id,
      name: song.song,
      type: song.type,
      mediaPreview: song.mediaPreviewUrl,
      album: SongResponseAlbum(
        id: song.albumId,
        name: song.album,
        url: song.albumUrl,
      ),
      year: song.year,
      releaseDate: song.releaseDate ?? "",
      duration: song.duration,
      label: song.label,
      primaryArtists: song.primaryArtists,
      primaryArtistsId: song.primaryArtistsId,
      featuredArtists: song.featuredArtists,
      featuredArtistsId: song.featuredArtistsId,
      explicitContent: song.explicitContent,
      playCount: song.playCount,
      language: song.language,
      hasLyrics: song.hasLyrics,
      url: song.permaUrl,
      copyright: song.copyrightText,
      image: createImageLinks(song.image),
      downloadUrl: createDownloadLinks(song.encryptedMediaUrl),
    );
  }


  factory SongResponse.fromJson(Map<String, dynamic> json) =>
      _$SongResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SongResponseToJson(this);
}

class PlaylistSongResponse{
  final String id;
  final String name;
  PlaylistSongResponse({
    required this.id, required this.name});

  factory PlaylistSongResponse.fromPlaylistSongResponse(PlaylistSongResponse song){
    return PlaylistSongResponse(id: song.id, name: song.name);
  }

  factory PlaylistSongResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaylistSongResponse(json);

}

@JsonSerializable()
class SongResponseAlbum {
  String id;
  String name;
  String url;

  SongResponseAlbum({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SongResponseAlbum.fromJson(Map<String, dynamic> json) =>
      _$SongResponseAlbumFromJson(json);

  Map<String, dynamic> toJson() => _$SongResponseAlbumToJson(this);
}
