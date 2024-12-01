import 'package:signum_beat/api/jiosaavn/models/album.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../providers/albumProvider.dart';
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

class AlbumDetails extends StatelessWidget {
  final String albumId;

  AlbumDetails({Key? key, required this.albumId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uniVarProvider = Provider.of<UniVarProvider>(context);
    final playSongProvider = Provider.of<PlaySongProvider>(context);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var appBarState = Provider.of<AppBarState>(context);

    return FloatingPlayerBody(
      body: ChangeNotifierProvider(
        create: (_) => AlbumProvider(id: albumId)..getAlbumData(),
        child: Consumer<AlbumProvider>(
          builder: (context, albumProvider, child) {
            if (albumProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (albumProvider.albumDetails == null) {
              return const Scaffold(
                body: Center(
                  child: NormalText(text: 'No data available'),
                ),
              );
            }
            var data = albumProvider.albumDetails;
            return CustomScrollView(
              controller: appBarState.scrollController,
              clipBehavior: Clip.antiAlias,
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
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
                                    image:
                                        NetworkImage(data!.image!.last.link)),
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
                                    text: HtmlUnescape().convert(
                                        data.primaryArtists.toString()),
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var song = data.songs[index];
                      return SongTile(
                        song: song,
                        onTap: () {
                          playSongProvider.playSong(song, index);
                          UniVarProvider.data = data.songs;
                        },
                      );
                    },
                    childCount: data.songs.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: albumProvider.primArtist.length,
                          itemBuilder: (context, index) {
                            var artist = albumProvider.primArtist[index];
                            return CustomCard(
                              size: 120.h,
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

                      ///Recommended Albums
                      albumProvider.recoAlbum.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Recommended Albums",
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
                      albumProvider.recoAlbum.isNotEmpty
                          ? SizedBox(
                              height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: albumProvider.recoAlbum.length,
                                itemBuilder: (context, index) {
                                  var album = albumProvider.recoAlbum[index];
                                  return CustomCard(
                                    leading: Image(
                                        image: NetworkImage(
                                            album.image!.last.link)),
                                    title: NormalText(
                                      text: album.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () async {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (_) =>
                                                AlbumProvider(id: album.id),
                                            child:
                                                AlbumDetails(albumId: album.id),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : CustomCardShimmer(
                              size: 140.h,
                            ),

                      ///Album Of Same Year///
                      albumProvider.albumFromSameYear.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.all(5.h),
                              child: const NormalText(
                                text: "Album Of Same Year",
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
                      albumProvider.albumFromSameYear.isNotEmpty
                          ? SizedBox(
                        height: 140.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    albumProvider.albumFromSameYear.length,
                                itemBuilder: (context, index) {
                                  var album =
                                      albumProvider.albumFromSameYear[index];
                                  return CustomCard(
                                      size: 100.h,
                                      leading: Image(
                                          image: NetworkImage(
                                              album.image!.last.link)),
                                      title: NormalText(
                                        text: album.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                              create: (_) =>
                                                  AlbumProvider(id: album.id),
                                              child: AlbumDetails(
                                                  albumId: album.id),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              ),
                            )
                          : CustomCardShimmer(size: 100.h),

                      ///Trending Album///
                      albumProvider.albumTrending.isNotEmpty
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
                      albumProvider.albumTrending.isNotEmpty
                          ? SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: albumProvider.albumTrending.length,
                          itemBuilder: (context, index) {
                            var album =
                            albumProvider.albumTrending[index];
                            return CustomCard(
                                size: 100.h,
                                leading: Image(
                                    image: NetworkImage(
                                        album.image!.last.link)),
                                title: NormalText(
                                  text: album.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChangeNotifierProvider(
                                            create: (_) =>
                                                AlbumProvider(id: album.id),
                                            child: AlbumDetails(
                                                albumId: album.id),
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
                ),

                /*SliverToBoxAdapter(
                  child:
                ),
                SliverToBoxAdapter(
                  child:
                )*/
              ],
            );
          },
        ),
      ),
    );
  }

  albumData(BuildContext context, AlbumResponse? data) {}
}

/*Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  body: Container(
                    height: h * .45,
                    width: w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          data?.image?.last.link ?? appImage,
                        ),
                        fit:
                            BoxFit.cover, // Example: Cover the entire container
                      ),
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // stops: [0.5, 1.0], // Example: Start gradient halfway down
                      ),
                    ),
                  ),
                ),
                SlidingUpPanelWidget(
                  controlHeight: 200,
                  anchor: .5,
                  minimumBound: 0.1,
                  upperBound: 0.41,
                  panelController: panelController,
                  onTap: () {
                    if (SlidingUpPanelStatus.expanded ==
                        panelController.status) {
                      panelController.collapse();
                    } else {
                      panelController.expand();
                    }
                  },
                  enableOnTap: true,
                  dragUpdate: (details) {},
                  child: Container(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).cardColor,
                        shadows: [
                          BoxShadow(
                              blurRadius: 1.0,
                              spreadRadius: 2.0,
                              color: const Color(0x11000000))
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.horizontal_rule),
                          Stack(
                            children: [

                              Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      NormalText(
                                        text: HtmlUnescape()
                                            .convert(data!.name.toString()),
                                        fontSize: 18,
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: HtmlUnescape().convert(
                                                  data.year.toString()),
                                              style: TextStyle(fontSize: 12,color: Colors.blueGrey)),
                                          TextSpan(
                                              text: HtmlUnescape()
                                                  .convert(' - Album - '),
                                              style: TextStyle(fontSize: 12,color: Colors.blueGrey)),
                                          TextSpan(
                                              text: HtmlUnescape().convert(data
                                                  .primaryArtists
                                                  .toString()),
                                              style: TextStyle(fontSize: 12,color: Colors.blueGrey)),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                  right: 20,
                                  bottom: 5,
                                  child: Wrap(
                                    spacing: 10,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.heart,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            {
                                              playSongProvider.playSong(
                                                  data.songs[0], 0);
                                              UniVarProvider.data = data.songs;
                                            }
                                          },
                                          icon: Icon(
                                            CupertinoIcons.play_arrow,
                                          )),
                                    ],
                                  )),
                            ],
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  NormalText(text: "Songs"),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data.songs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var song = data.songs[index];
                                      return SongTile(
                                          song: song,
                                          onTap: () {
                                            playSongProvider.playSong(
                                                song, index);
                                            UniVarProvider.data = data.songs;
                                          });
                                    },
                                  ),
                                  NormalText(text: "Artists"),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          albumProvider.primArtist.length,
                                      itemBuilder: (context, index) {
                                        var artist =
                                            albumProvider.primArtist[index];

                                        return CustomCard(
                                          size: 180,
                                          leading: Image(
                                              image: NetworkImage(
                                                  artist.image!.last.link)),
                                          title: NormalText(
                                            text: artist.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                        );
                                      },
                                    ),
                                  ),
                                  NormalText(text: "Recommended Albums"),
                                  albumProvider.recoAlbum.isNotEmpty?SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: albumProvider.recoAlbum.length,
                                      itemBuilder: (context, index) {
                                        var album =
                                            albumProvider.recoAlbum[index];
                                        return CustomCard(
                                            size: 180,
                                            leading: Image(
                                                image: NetworkImage(
                                                    album.image!.last.link)),
                                            title: NormalText(
                                              text: album.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider(
                                                    create: (_) =>
                                                        AlbumProvider(
                                                            id: album.id),
                                                    child: AlbumDetails(
                                                        albumId: album.id),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ):SizedBox(),
                                  NormalText(text: "Album Of Same Year"),
                                  albumProvider.albumFromSameYear.isNotEmpty?SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: albumProvider.albumFromSameYear.length,
                                      itemBuilder: (context, index) {
                                        var album =
                                            albumProvider.albumFromSameYear[index];
                                        return CustomCard(
                                            size: 180,
                                            leading: Image(
                                                image: NetworkImage(
                                                    album.image!.last.link)),
                                            title: NormalText(
                                              text: album.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider(
                                                    create: (_) =>
                                                        AlbumProvider(
                                                            id: album.id),
                                                    child: AlbumDetails(
                                                        albumId: album.id),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                    ),
                                  ):SizedBox(),
                                  SizedBox(height: 400,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ],
            );*/
