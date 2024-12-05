import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signum_beat/widgets/global_widget/floating_player.dart';
import 'package:signum_beat/widgets/tile/songTile.dart';

import '../../api/jiosaavn/jiosaavn.dart';
import '../../api/jiosaavn/models/artist.dart';
import '../../providers/albumProvider.dart';
import '../../providers/artist_provider.dart';
import '../../widgets/tile/custom_tile.dart';
import '../tileDetails/albumDetail.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/jiosaavn/jiosaavn.dart';
import '../../providers/artist_provider.dart';
import '../../widgets/tile/custom_tile.dart';

class ArtistMoreDetail extends StatelessWidget {
  final String artistId;

  const ArtistMoreDetail({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ArtistMoreDetailProvider>();

    // Fetch details for both tabs initially
    provider.getArtistMoreDetails(artistId, reset: true);
    provider.getArtistMoreSong(artistId, reset: true);

    return FloatingPlayerBody(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Artist Details'),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Songs"),
                Tab(text: "Albums"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Songs Tab
              Column(
                children: [
                  // Sort Dropdown for Songs
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sort by:"),
                        DropdownButton<String>(
                          value: provider.sortBy,
                          items: const [
                            DropdownMenuItem(
                              value: 'name',
                              child: Text('Name'),
                            ),
                            DropdownMenuItem(
                              value: 'year',
                              child: Text('Year'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              provider.sortSongs(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            scrollNotification.metrics.pixels ==
                                scrollNotification.metrics.maxScrollExtent) {
                          provider.getArtistMoreSong(artistId);
                        }
                        return false;
                      },
                      child: Consumer<ArtistMoreDetailProvider>(
                        builder: (context, artistProvider, child) {
                          final songs = artistProvider.artistSong.results;
      
                          if (songs.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
      
                          return ListView.builder(
                            itemCount: songs.length +
                                (artistProvider.artistSong.lastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == songs.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
      
                              final song = songs[index];
                              return SongTile(
                                song: song,
                                onTap: () {
                                  // Handle song tap
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      
              // Albums Tab
              Column(
                children: [
                  // Sort Dropdown for Albums
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Sort by:"),
                        DropdownButton<String>(
                          value: provider.sortBy,
                          elevation:0,
                          items: const [
                            DropdownMenuItem(
                              value: 'name',
                              child: Text('Name'),
                            ),
                            DropdownMenuItem(
                              value: 'year',
                              child: Text('Year'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              provider.sortAlbums(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            scrollNotification.metrics.pixels ==
                                scrollNotification.metrics.maxScrollExtent) {
                          provider.getArtistMoreDetails(artistId);
                        }
                        return false;
                      },
                      child: Consumer<ArtistMoreDetailProvider>(
                        builder: (context, artistProvider, child) {
                          final albums = artistProvider.artistAlbum.results;
      
                          if (albums.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
      
                          return ListView.builder(
                            itemCount: albums.length +
                                (artistProvider.artistAlbum.lastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == albums.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
      
                              final album = albums[index];
                              return CustomTile(
                                image: album.image!.last.link,
                                title: album.name,
                                subTitle: album.subTitle,
                                type: album.type ?? '',
                                artists: album.featuredArtists ?? '',
                                count: album.songCount,
                                year: album.year,
                                onTap: () {
                                  // Handle album tap
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}






class ArtistMoreDetailProvider extends ChangeNotifier {

  final JioSaavnClient jio = JioSaavnClient();



  ArtistSongResponse _artistSong = ArtistSongResponse(total: 0, lastPage: false, results: []);
  ArtistAlbumResponse _artistAlbum = ArtistAlbumResponse(total: 0, lastPage: false, results: []);
  int _currentPage = 1;
  bool _isMoreLoading = false;
  String sortBy = 'name';

  // Getters for each property

  ArtistSongResponse get artistSong => _artistSong;
  ArtistAlbumResponse get artistAlbum => _artistAlbum;
  bool get isMoreLoading => _isMoreLoading;




  Future<void> getArtistMoreDetails(String artistId, {bool reset = false}) async {
    if (reset) {
      _artistAlbum = ArtistAlbumResponse(total: 0, lastPage: false, results: []);
      _currentPage = 1;
      _isMoreLoading = false;
      notifyListeners();
    }

    if (_isMoreLoading || _artistAlbum.lastPage) return;

    _isMoreLoading = true;
    notifyListeners();

    try {
      var newAlbums = await jio.artists.artistAlbums(artistId, page: _currentPage);
      _artistAlbum.results.addAll(newAlbums.results);
      _artistAlbum = _artistAlbum.copyWith(lastPage: newAlbums.lastPage);
      _currentPage++;
    } catch (e, st) {
      print("$e \n $st");
    } finally {
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> getArtistMoreSong(String artistId, {bool reset = false}) async {
    if (reset) {
      _artistSong = ArtistSongResponse(total: 0, lastPage: false, results: []);
      _currentPage = 1;
      _isMoreLoading = false;
      notifyListeners();
    }

    if (_isMoreLoading || _artistSong.lastPage) return;

    _isMoreLoading = true;
    notifyListeners();

    try {
      var newAlbums = await jio.artists.artistSongs(artistId, page: _currentPage);
      _artistSong.results.addAll(newAlbums.results);
      _artistSong = _artistSong.copyWith(lastPage: newAlbums.lastPage);
      _currentPage++;
    } catch (e, st) {
      print("$e \n $st");
    } finally {
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  void sortAlbums(String sortOption) {
    sortBy = sortOption;

    if (sortBy == 'name') {
      _artistAlbum.results.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortBy == 'year') {
      _artistAlbum.results.sort((a, b) => a.year.compareTo(b.year));
    }

    notifyListeners();
  }

  void sortSongs(String sortOption) {
    sortBy = sortOption;

    if (sortBy == 'name') {
      _artistSong.results.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (sortBy == 'year') {
      _artistSong.results.sort((a, b) => a.year.compareTo(b.year));
    }else if (sortBy == 'popular'){

    }

    notifyListeners();
  }

}

