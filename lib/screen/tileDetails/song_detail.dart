import 'package:signum_beat/providers/song_detail_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import '../../api/jiosaavn/models/song.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../providers/state_provider/app_bar_state_provider.dart';
import '../../utils/constants/const_var.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/global_widget/floating_player.dart';
import '../../widgets/shimmer/custom_card_shimmer.dart';
import '../../widgets/shimmer/title_shimmer.dart';
import '../../widgets/text_widget/normal_text.dart';
import '../../widgets/tile/songTile.dart';

class SongDetails extends StatelessWidget {
  final SongResponse song;

   SongDetails({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final playSongProvider = Provider.of<PlaySongProvider>(context);

    var appBarState = Provider.of<AppBarState>(context);

    return ChangeNotifierProvider(
      create: (_) => SongProvider(id: song.id),
      child: Consumer<SongProvider>(builder: (context, SongProvider, child) {
        if (SongProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (SongProvider.song == null) {
          return const Scaffold(
            body: Center(
              child: NormalText(text: 'No data available'),
            ),
          );
        }

        var data = SongProvider.song;

        return Scaffold(
            body: FloatingPlayerBody(
          body: CustomScrollView(
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
                                  image: NetworkImage(data!.image!.last.link)),
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
                      .move(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0)),
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
                            text: HtmlUnescape().convert(data.name.toString()),
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: HtmlUnescape()
                                      .convert(data.year.toString()),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  )),
                              TextSpan(
                                  text: HtmlUnescape().convert(' - Album - '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  )),
                              TextSpan(
                                  text: HtmlUnescape()
                                      .convert(data.primaryArtists.toString()),
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
                        data.image!.last.link,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(
                            0.5), // Adjust color and opacity as needed
                      ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SongTile(
                    inSongDetails: true,
                    song: data,
                    onTap: () {
                      playSongProvider.playSong(song, 0);
                      UniVarProvider.data = [data];
                    },
                  ),

                  ///artist///
                  Padding(
                    padding: EdgeInsets.all(5.h),
                    child: const NormalText(
                      text: "Artists",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: SongProvider.primaryArtist.length,
                      itemBuilder: (context, index) {
                        var artist = SongProvider.primaryArtist[index];
                        return CustomCard(
                          size: 120.w,
                          leading: Image(
                              image: NetworkImage(artist.image!.last.link
                                  .contains('https://static')
                                  ? appImage
                                  : artist.image!.last.link)),
                          title: NormalText(
                            text: artist.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        );
                      },
                    ),
                  ),

                  ///Recommended songs///
                  SongProvider.recoSong.isNotEmpty
                      ? Padding(
                    padding: EdgeInsets.all(5.h),
                    child: const NormalText(
                      text: "Recommended Top Song",
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
                  SongProvider.recoSong.isNotEmpty
                      ? SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: SongProvider.recoSong.length,
                      itemBuilder: (context, index) {
                        var song = SongProvider.recoSong[index];
                        return CustomCard(
                          size: 130.w,
                          leading: Image(
                              image: NetworkImage(song.image!.last.link)),
                          title: NormalText(
                            text: song.name ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            playSongProvider.playSong(song, 0);
                            UniVarProvider.data = [data];
                          },
                        );
                      },
                    ),
                  )
                      : CustomCardShimmer(
                    size: 140.h,
                  ),

                  ///Other top song
                  SongProvider.otherTopSong.isNotEmpty
                      ? Padding(
                    padding: EdgeInsets.all(5.h),
                    child: const NormalText(
                      text: "Recommended Top Song",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      textAlign: TextAlign.start,
                    ),
                  )
                      : Align(
                    alignment: Alignment.centerLeft,
                    // Align shimmer to the left
                    child: SizedBox(
                      width: 150.w, // Constrain shimmer width
                      child: const TitlePlaceholder(width: 200),
                    ),
                  ),
                  SongProvider.otherTopSong.isNotEmpty
                      ? SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: SongProvider.otherTopSong.length,
                      itemBuilder: (context, index) {
                        var song = SongProvider.otherTopSong[index];
                        return CustomCard(
                          size: 130.w,
                          leading: Image(
                              image: NetworkImage(song.image!.last.link)),
                          title: NormalText(
                            text: song.name ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            playSongProvider.playSong(song, 0);
                            UniVarProvider.data = [data];
                          },
                        );
                      },
                    ),
                  )
                      : CustomCardShimmer(
                    size: 140.h,
                  ),

                  ///Other top song
                  SongProvider.trendingSong.isNotEmpty
                      ? Padding(
                    padding: EdgeInsets.all(5.h),
                    child: const NormalText(
                      text: "Recommended Top Song",
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
                  SongProvider.trendingSong.isNotEmpty
                      ? SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: SongProvider.otherTopSong.length,
                      itemBuilder: (context, index) {
                        var song = SongProvider.trendingSong[index];
                        return CustomCard(
                          size: 130.w,
                          leading: Image(
                              image: NetworkImage(song.image!.last.link)),
                          title: NormalText(
                            text: song.name ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            playSongProvider.playSong(song, 0);
                            UniVarProvider.data = [data];
                          },
                        );
                      },
                    ),
                  )
                      : CustomCardShimmer(
                    size: 140.h,
                  ),

                  // Visibility(
                  //   visible: SongProvider.lyricsResponse!= null,
                  //     child: NormalText(text: SongProvider.lyricsResponse!.lyrics!))

                ],
              )),












            ],
          ),
        ));
      }),
    );
  }
}
