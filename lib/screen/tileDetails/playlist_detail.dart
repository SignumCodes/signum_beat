import 'package:signum_beat/providers/song_detail_provider.dart';
import 'package:signum_beat/screen/tileDetails/song_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../providers/albumProvider.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/state_provider/app_bar_state_provider.dart';
import '../../utils/constants/const_var.dart';
import '../../widgets/cards/playlistCard.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/global_widget/floating_player.dart';
import '../../widgets/shimmer/custom_card_shimmer.dart';
import '../../widgets/shimmer/title_shimmer.dart';
import '../../widgets/text_widget/normal_text.dart';
import '../../widgets/tile/songTile.dart';
import 'albumDetail.dart';

class PlayListDetail extends StatefulWidget {
  final String playlistId;

  const PlayListDetail({super.key, required this.playlistId});

  @override
  State<PlayListDetail> createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlayListDetail> {
  @override
  Widget build(BuildContext context) {
    var appBarState = Provider.of<AppBarState>(context);
    // final uniVarProvider = Provider.of<UniVarProvider>(context);
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    return FloatingPlayerBody(
      body: ChangeNotifierProvider(
        create: (_) =>
            PlaylistProvider()..getPlaylistDetails(widget.playlistId),
        child: Consumer<PlaylistProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (provider.playlistDetails == null) {
            return const Scaffold(
              body: Center(
                child: NormalText(text: 'No data available'),
              ),
            );
          }
          var data = provider.playlistDetails!;
          return Scaffold(
            body: CustomScrollView(
              controller: appBarState.scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: appBarState.appBarHeight.h,
                  leading: IconButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(Colors.black26)),
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  pinned: true,
                  centerTitle: true,
                  title: Visibility(
                    visible: appBarState.isAppBarCollapsed,
                    child: SizedBox(
                      width: 70,
                      height: 50,
                      child: Stack(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(data.image!)),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.play_circle,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                // Handle play button press
                              },
                            ),
                          ) // runs after the above w/new duration
                        ],
                      ),
                    )
                        .animate(
                          delay: 100.ms,
                        )
                        .scale()
                        .move(
                            begin: const Offset(-1.0, 0.0),
                            end: const Offset(0.0, 0.0)),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Visibility(
                      visible: !appBarState.isAppBarCollapsed,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            NormalText(
                              text:
                                  HtmlUnescape().convert(data.name.toString()),
                              fontSize: 14.dg,
                              color: Colors.white,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: HtmlUnescape()
                                        .convert(data.songCount.toString()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    )),
                                TextSpan(
                                    text: HtmlUnescape()
                                        .convert(' - Playlist - '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    )),
                                TextSpan(
                                    text: HtmlUnescape()
                                        .convert(data.fanCount.toString()),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    )),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          data.image!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(
                              0.5), // Adjust color and opacity as needed
                        ),
                        Positioned(
                            left: 12.w,
                            top: 2.h,
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundImage: NetworkImage(appImage),
                            )),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: const Size(double.maxFinite, 30),
                      child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: appBarState.isScrolling
                              ? const Icon(Icons.horizontal_rule)
                              : const Icon(Icons.keyboard_arrow_up_rounded))),
                ),
                provider.playlistSong.isNotEmpty
                    ? SliverList(
                        // Displaying songs in a list
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Assuming data.songs is a list of songs
                            final song = provider.playlistSong[index];
                            return SongTile(
                              song: song,
                              onTap: () {
                                playSongProvider.playSong(song, index);
                                UniVarProvider.data = provider.playlistSong;
                              },
                            );
                          },
                          childCount: provider.playlistSong.length,
                        ),
                      )
                    : CustomCardShimmer(
                        size: 140.h,
                      ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Recommended Playlist
                      provider.recoPlaylist.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Recommended Playlist",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const Align(
                              alignment: Alignment.centerLeft,
                              // Align shimmer to the left
                              child: SizedBox(
                                width: 200, // Constrain shimmer width
                                child: TitlePlaceholder(width: 200),
                              ),
                            ),

                      provider.recoPlaylist.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.recoPlaylist.length,
                                itemBuilder: (context, index) {
                                  var playlist = provider.recoPlaylist[index];
                                  return PlaylistCard(
                                    title: NormalText(
                                      text: playlist.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: Image(
                                        image: NetworkImage(playlist.image)),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (_) => PlaylistProvider(),
                                            child: PlayListDetail(
                                              playlistId: playlist.id!,
                                            ),
                                          ),
                                        ),
                                      );
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayListDetail(playlistId: playlist[index]['id'],)));
                                    },
                                  );
                                },
                              ),
                            )
                          : CustomCardShimmer(size: 140.h),

                      ///Trending Song///
                      provider.trendingSong.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Trending Song",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const Align(
                              alignment: Alignment.centerLeft,
                              // Align shimmer to the left
                              child: SizedBox(
                                width: 200, // Constrain shimmer width
                                child: TitlePlaceholder(width: 200),
                              ),
                            ),
                      provider.trendingSong.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.trendingSong.length,
                                itemBuilder: (context, index) {
                                  var song = provider.trendingSong[index];
                                  return CustomCard(
                                      size: 100.h,
                                      leading: Image(
                                          image: NetworkImage(
                                              song.image!.last.link)),
                                      title: NormalText(
                                        text: song.name!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () async {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         ChangeNotifierProvider(
                                        //           create: (_) =>
                                        //               SongProvider(id: song.id),
                                        //           child: SongDetails(
                                        //               song: song),
                                        //         ),
                                        //   ),
                                        // );
                                        playSongProvider.playSong(song, 0);
                                        UniVarProvider.data =
                                            provider.trendingSong;
                                      });
                                },
                              ),
                            )
                          : CustomCardShimmer(size: 100.h),

                      ///Recommended Trending playlist
                      provider.playlistTrending.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Trending Playlist",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const Align(
                              alignment: Alignment.centerLeft,
                              // Align shimmer to the left
                              child: SizedBox(
                                width: 200, // Constrain shimmer width
                                child: TitlePlaceholder(width: 200),
                              ),
                            ),
                      provider.playlistTrending.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.playlistTrending.length,
                                itemBuilder: (context, index) {
                                  var playlist =
                                      provider.playlistTrending[index];
                                  return PlaylistCard(
                                    title: NormalText(
                                      text: playlist.name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: Image(
                                        image: NetworkImage(playlist.image)),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (_) => PlaylistProvider(),
                                            child: PlayListDetail(
                                              playlistId: playlist.id!,
                                            ),
                                          ),
                                        ),
                                      );
                                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayListDetail(playlistId: playlist[index]['id'],)));
                                    },
                                  );
                                },
                              ),
                            )
                          : CustomCardShimmer(size: 140.h),

                      ///Trending Album///
                      provider.trendingAlbum.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Trending Album",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                textAlign: TextAlign.start,
                              ),
                            )
                          : const Align(
                              alignment: Alignment.centerLeft,
                              // Align shimmer to the left
                              child: SizedBox(
                                width: 200, // Constrain shimmer width
                                child: TitlePlaceholder(width: 200),
                              ),
                            ),
                      provider.trendingAlbum.isNotEmpty
                          ? SizedBox(
                              height: 200.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.trendingAlbum.length,
                                itemBuilder: (context, index) {
                                  var album =
                                      provider.trendingAlbum[index]['details'];
                                  return CustomCard(
                                      size: 100.h,
                                      leading: Image(
                                          image: NetworkImage(album['image'])),
                                      title: NormalText(
                                        text: album['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                              create: (_) => AlbumProvider(
                                                  id: album['albumid']),
                                              child: AlbumDetails(
                                                  albumId: album['albumid']),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            )
                          : CustomCardShimmer(size: 100.h),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
