import 'package:signum_beat/providers/artist_provider.dart';
import 'package:signum_beat/screen/artist/artist_more_detail.dart';
import 'package:signum_beat/screen/tileDetails/playlist_detail.dart';
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
import '../../widgets/tile/custom_tile.dart';
import '../../widgets/tile/songTile.dart';
import 'albumDetail.dart';

class ArtistDetail extends StatelessWidget {
  final String artistId;

  const ArtistDetail({
    super.key,
    required this.artistId,
  });

  @override
  Widget build(BuildContext context) {
    var appBarState = Provider.of<AppBarState>(context);
    // final uniVarProvider = Provider.of<UniVarProvider>(context);
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    return FloatingPlayerBody(
      body: ChangeNotifierProvider(
        create: (_) => ArtistProvider()..getArtistDetails(artistId),
        child: Consumer<ArtistProvider>(builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (provider.artistDetail == null) {
            return const Scaffold(
              body: Center(
                child: NormalText(text: 'No data available'),
              ),
            );
          }
          var data = provider.artistDetail;
          return Scaffold(
            body: CustomScrollView(
              controller: appBarState.scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: appBarState.appBarHeight.h,
                  leading: IconButton(
                    style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.black26)),
                    icon: const Icon(CupertinoIcons.back,color: Colors.white,),
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
                                    image: NetworkImage(
                                  provider.artistDetail['image'],
                                )),
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
                              text: HtmlUnescape()
                                  .convert(provider.artistDetail['name']),
                              fontSize: 14.dg,
                              color: Colors.white,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: HtmlUnescape().convert(
                                        provider.artistDetail['type']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    )),
                                TextSpan(
                                    text: '- fan -',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    )),
                                TextSpan(
                                    text: HtmlUnescape().convert(provider
                                        .artistDetail['follower_count']),
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
                          provider.artistDetail['image'],
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(5.h),
                    child:  const NormalText(
                      text: "Popular Song",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                provider.topSongs.isNotEmpty
                    ? SliverList(
                        // Displaying songs in a list
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Assuming data.songs is a list of songs
                            final song = provider.topSongs[index];
                            return SongTile(
                              song: song,
                              onTap: () {
                                playSongProvider.playSong(song, index);
                                UniVarProvider.data = provider.topSongs;
                              },
                            );
                          },
                          childCount: 6,
                        ),
                      )
                    : CustomCardShimmer(
                        size: 140.h,
                      ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Artist popular release
                      provider.topAlbums.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Popular Release",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          : const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 200, // Constrain shimmer width
                                child: TitlePlaceholder(width: 200),
                              ),
                            ),
                      provider.topAlbums.isNotEmpty
                          ? ListView.builder(
                            padding:EdgeInsets.zero,
                                                  shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.topAlbums.length>=4?4:provider.topAlbums.length,
                            itemBuilder: (context, index) {
                              var album = provider.topAlbums[index];
                              return CustomTile(
                                image:album['image'],
                                title: album['title'],
                                subTitle: album['subtitle'],
                                type: album['type'],
                                artists: album['more_info']['music'],
                                count: album['more_info']['song_count'],
                                year: album['year'],
                                onTap: () =>Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (_) =>
                                              AlbumProvider(id: album['id']),
                                          child: AlbumDetails(
                                              albumId: album['id']),
                                        ),
                                  ),
                                ),
                              );
                            },
                          )
                          : CustomCardShimmer(size: 100.h),

                      ///Only by artist///
                      provider.singleAlbums.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child:  NormalText(
                                text: "Only By ${provider.artistDetail['name']}",
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
                      provider.singleAlbums.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: provider.singleAlbums.length,
                                itemBuilder: (context, index) {
                                  var album = provider.singleAlbums[index];
                                  return CustomCard(
                                    size: 150.w,
                                    leading: Image(
                                      image: NetworkImage(album['image']),
                                    ),
                                    title: NormalText(
                                      text: album['title'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () =>Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (_) =>
                                                  AlbumProvider(id: album['id']),
                                              child: AlbumDetails(
                                                  albumId: album['id']),
                                            ),
                                      ),
                                    )
                                  );
                                },
                              ))
                          : CustomCardShimmer(size: 100.h),

                      ///Dedicated  Playlist
                      provider.dedicatedArtistPlaylists.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Dedicated Playlist",
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
                      provider.dedicatedArtistPlaylists.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    provider.dedicatedArtistPlaylists.length,
                                itemBuilder: (context, index) {
                                  var playlist =
                                      provider.dedicatedArtistPlaylists[index];
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

                      ///Featured Playlist///
                      provider.featuredArtistPlaylist.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Featured Playlist",
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
                      provider.featuredArtistPlaylist.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount:
                                      provider.featuredArtistPlaylist.length,
                                  itemBuilder: (c, i) {
                                    var playlist =
                                        provider.featuredArtistPlaylist[i];
                                    return PlaylistCard(
                                      size: 180,
                                      leading: Image(
                                        image: NetworkImage(playlist['image']),
                                      ),
                                      title: NormalText(
                                        text: playlist['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () =>
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                    create: (_) => PlaylistProvider(),
                                                    child: PlayListDetail(
                                                      playlistId: playlist['id']!,
                                                    ),
                                                  ),
                                            ),
                                          )
                                    );
                                  }),
                            )
                          : CustomCardShimmer(size: 100.h),

                      ///New release///
                      provider.latestReleaseAlbum.isNotEmpty
                          ? Padding(
                        padding: EdgeInsets.all(5.h),
                        child: const NormalText(
                          text: "Popular Release",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                          : const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200, // Constrain shimmer width
                          child: TitlePlaceholder(width: 200),
                        ),
                      ),
                      provider.latestReleaseAlbum.isNotEmpty
                          ? ListView.builder(
                        padding:EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.latestReleaseAlbum.length,
                        itemBuilder: (context, index) {
                          var album = provider.latestReleaseAlbum[index];
                          return CustomTile(
                            image:album['image'],
                            title: album['title'],
                            subTitle: album['subtitle'],
                            type: album['type'],
                            artists: album['more_info']['music']??provider.artistDetail['name'],
                            count: album['more_info']['song_count'],
                            year: album['year'],
                            onTap: () =>Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider(
                                      create: (_) =>
                                          AlbumProvider(id: album['id']),
                                      child: AlbumDetails(
                                          albumId: album['id']),
                                    ),
                              ),
                            ),
                          );
                        },
                      )
                          : CustomCardShimmer(size: 100.h),

                      GestureDetector(
                        onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ArtistMoreDetail(artistId: artistId))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NormalText(text: 'More ${provider.artistDetail['name']}'),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(height: 100,)
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
