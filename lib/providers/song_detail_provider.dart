import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/jiosaavn/jiosaavn.dart';
import '../api/jiosaavn/models/artist.dart';
import '../api/jiosaavn/models/lyrics.dart';
import '../api/jiosaavn/models/song.dart';

class SongProvider extends ChangeNotifier{


   SongProvider({this.id}){
      getTrendingSong(id!);
      getSongDetails(id!);
      getRecommonededSong(id!);
      getArtistOtherTopSong(id!);
      getLyrics(id!);
   }
   final String? id;
    List<ArtistResponse> _pArtist=[];
    List<ArtistResponse> _fArtist=[];
    SongResponse? _song;
    List<SongResponse> _recoSong=[];
    List<SongResponse> _otherTopSong=[];
    List<SongResponse> _trendingSong=[];
   LyricsResponse? _lyricsResponse ;
   bool _isLoading = false;

   final JioSaavnClient jio = JioSaavnClient();


   SongResponse? get song => _song;
   List<SongResponse> get recoSong =>_recoSong;
   List<SongResponse> get otherTopSong =>_otherTopSong;
   List<SongResponse> get trendingSong =>_trendingSong;
   List<ArtistResponse> get primaryArtist => _pArtist;
   List<ArtistResponse> get featuredArtist => _fArtist;
   LyricsResponse? get lyricsResponse => _lyricsResponse;
   bool get isLoading => _isLoading;



   Future<void> getSongDetails(String songId) async {
      _isLoading = true;
      notifyListeners();
      _song = await jio.songs.detailsById(songId);
      _isLoading = false;
      notifyListeners();
      // _song!.featuredArtistsId.split(', ').map((e) => jio.artists.detailsById(e)).toList();
      var futurePArtist = _song!.primaryArtistsId.split(', ').map((e) => jio.artists.detailsById(e)).toList();
      _pArtist = await Future.wait(futurePArtist.where((element) => element !=null));

      getRecommonededSong(songId);
      notifyListeners();
      getArtistOtherTopSong(songId);
      notifyListeners();
      getTrendingSong(songId);
      notifyListeners();
      getLyrics(songId);
      notifyListeners();
   }
   Future<void> getRecommonededSong(String songId) async {
      _recoSong =await jio.songs.getReco(songId);
   }
   Future<void> getArtistOtherTopSong(String songId) async {
     _otherTopSong = await jio.songs.artistOtherTopSong(songId);
   }
   Future<void> getTrendingSong(String songId) async {
     _trendingSong = await jio.songs.getTrendingSong(songId);
   }
   Future<void> getLyrics(String songId) async {
      _lyricsResponse = await jio.lyrics.get(songId);
   }


}