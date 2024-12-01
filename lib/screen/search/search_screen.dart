import 'package:signum_beat/screen/tileDetails/albumDetail.dart';
import 'package:signum_beat/screen/tileDetails/artist_detail.dart';
import 'package:signum_beat/screen/tileDetails/playlist_detail.dart';
import 'package:signum_beat/screen/tileDetails/song_detail.dart';
import 'package:signum_beat/utils/constants/const_var.dart';
import 'package:signum_beat/widgets/cards/playlistCard.dart';
import 'package:signum_beat/widgets/global_widget/floating_player.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/playSong/playSongProvider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/tile/custom_tile.dart';
import '../../widgets/tile/songTile.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);

    final searchProvider =
        Provider.of<SearchMusicProvider>(context, listen: true);

    return FloatingPlayerBody(
      body: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: TextField(
              controller: searchProvider.searchTextController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  searchProvider.getSearchModule(value);
                }
              },
              onSubmitted: (value) {
                searchProvider.getSearchModule(value);
              },
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: "Type something here",
                prefixIcon: const Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
        body: searchProvider.autoComplete.isEmpty ||
                searchProvider.searchTextController.text.isEmpty
            ? const Center(
                child: Text('Search Your Favourite Music'),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NormalText(text: 'Top Result'),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchProvider
                            .autoComplete.first.topQuery.results.length,
                        itemBuilder: (context, index) {
                          var topResult = searchProvider
                              .autoComplete.first.topQuery.results;
                          var data = topResult[index];
                          return data.type == 'song'
                              ? CustomCard(
                                  title: NormalText(
                                    text: data.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Image(
                                    image: NetworkImage(
                                        data.image!.last.link.toString()),
                                  ),
                                  onTap: () async {
                                    var song = await searchProvider.jio.songs
                                        .detailsById(data.id);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SongDetails(song: song)));
                                  },
                                )
                              : CustomCard(
                                  title: NormalText(
                                    text: data.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Image(
                                    image: NetworkImage(
                                        data.image!.last.link.toString()),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  onTap: () {
                                    if(data.type == 'artist'){
                                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>ArtistDetail(artistId: data.id)));
                                    }
                                  },
                                );
                        },
                      ),
                    ),
                    const NormalText(text: 'Top Songs'),
                    searchProvider.autoCompleteSongs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: searchProvider.autoCompleteSongs.length,
                            itemBuilder: (context, index) {
                              var song =
                                  searchProvider.autoCompleteSongs[index];
                              return SongTile(
                                song: song,
                                onTap: () {
                                  playSongProvider.playSong(song, 0);
                                  // UniVarProvider.data = [data];
                                },
                              );
                            },
                          )
                        : Container(),
                    const NormalText(text: 'Top Album'),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: searchProvider
                          .autoComplete.first.albums.results.length,
                      itemBuilder: (context, index) {
                        var album = searchProvider
                            .autoComplete.first.albums.results[index];
                        return CustomTile(
                          title: album.title.toString(),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=>AlbumDetails(albumId: album.id)));
                          },
                          subTitle: album.description,
                          type: album.type,
                          image: album.image!.last.link
                                  .toString()
                                  .startsWith('http')
                              ? album.image!.last.link.toString()
                              : appImage,
                          artists: album.artist.toString(),
                          year: album.year,
                        );
                      },
                    ),
                    const NormalText(text: 'Top Playlist'),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchProvider.autoCompletePlaylist.length,
                        itemBuilder: (context, index) {
                          var playlist =
                              searchProvider.autoCompletePlaylist[index];
                          return PlaylistCard(
                            title: NormalText(
                              text: playlist.name.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Image(
                              image: NetworkImage(
                                playlist.image.toString().startsWith('http')
                                    ? playlist.image.toString()
                                    : appImage,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>PlayListDetail(playlistId: playlist.id!)));

                            },
                          );
                        },
                      ),
                    ),
                    const NormalText(text: 'Top Artist'),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchProvider
                            .autoComplete.first.artists.results.length,
                        itemBuilder: (context, index) {
                          var topResult =
                              searchProvider.autoComplete.first.artists.results;
                          var data = topResult[index];
                          return CustomCard(
                            title: NormalText(
                              text: data.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Image(
                              image: NetworkImage(
                                  data.image!.last.link.toString()),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder)=>ArtistDetail(artistId: data.id)));


                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
