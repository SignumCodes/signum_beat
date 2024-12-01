

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/jiosaavn/jiosaavn.dart';
import '../api/jiosaavn/models/album.dart';
import '../api/jiosaavn/models/artist.dart';

class AlbumProvider with ChangeNotifier {
  final String? id;
  final JioSaavnClient jio = JioSaavnClient();

  AlbumResponse? _albumDetails;
  List<AlbumResponse> _recoAlbum = [];
  List<ArtistResponse> _primArist=[];
  List<AlbumResponse> _albumFromSameYear = [];
  List<AlbumResponse> _albumTrending = [];
  bool _isLoading = false;

  AlbumProvider({this.id});

  AlbumResponse? get albumDetails => _albumDetails;
  List<AlbumResponse> get recoAlbum => _recoAlbum;
  List<AlbumResponse> get albumFromSameYear => _albumFromSameYear;
  List<AlbumResponse> get albumTrending => _albumTrending;
  List<ArtistResponse> get primArtist => _primArist;
  bool get isLoading => _isLoading;

  Future<void> getAlbumData() async {
    _isLoading = true;
    notifyListeners();

      var data = await jio.albums.detailsById(id!);
      _albumDetails = data;
    _isLoading = false;
    notifyListeners();

    var artistFutures = data.primaryArtistsId
        .toString()
        .split(RegExp(r',\s*'))
        .where((element) => int.tryParse(element) != null)
        .map((e) => jio.artists.detailsById(e))
        .toList();
    _primArist = await Future.wait(artistFutures);
    notifyListeners();

    _recoAlbum = await jio.albums.getReco(id!);
    notifyListeners();

      _albumFromSameYear = await jio.albums.topAlbumsOfTheYear(albumDetails!.year);
    notifyListeners();

    _albumTrending = await jio.albums.trendingAlbum(id!);
    print(albumTrending.length);
    print(_albumTrending.length);
    notifyListeners();

    _isLoading = false;
   notifyListeners();
  }


  getPrimaryArtis() async {

    var artistFutures = albumDetails!.primaryArtistsId
        .toString()
        .split(RegExp(r',\s*'))
        .where((element) => int.tryParse(element) != null)
        .map((e) => jio.artists.detailsById(e))
        .toList();

    _primArist = await Future.wait(artistFutures);
      var reco = await jio.albums.getReco(id!);
      _albumFromSameYear = await jio.albums.topAlbumsOfTheYear(albumDetails!.year);


      _recoAlbum = reco;

  }



}