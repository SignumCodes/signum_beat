import 'package:signum_beat/api/jiosaavn/jiosaavn.dart';
import 'package:signum_beat/main.dart';
import 'package:signum_beat/providers/playSong/playSongProvider.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:html_unescape/html_unescape.dart';
// import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../../utils/constants/color_const.dart';
import '../../utils/constants/const_var.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/tile/songTile.dart';

class MainPlayer extends StatefulWidget {
  final List<dynamic> data;

  MainPlayer({super.key, required this.data});

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  double minBound = 0;
  double upperBound = 1.0;
  var jio = JioSaavnClient();

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize ScrollController
    scrollController = ScrollController();

    // Initialize AnimationController for rotation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Adjust for smoothness
    );

    // Define the rotation animation with a linear curve
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.1415926535897932) // Full rotation
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear, // Smooth constant speed
    ));

    // Define the color animation for the shadow
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _colorAnimation = ColorTween(
      begin: AppColor.mainColor,
      end: Colors.purple,
    ).animate(curvedAnimation);

    // Repeat the rotation animation
    _animationController.repeat(); // No reverse needed
  }


  @override
  void dispose() {
    _animationController.dispose();
    _animationController.dispose();
    panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playProvider = Provider.of<PlaySongProvider>(context);
    final uniVarProvider = Provider.of<UniVarProvider>(context);

    return Scaffold(
       // backgroundColor: Colors.red,
        body: Column(
          children: <Widget>[
            songResponseWidget(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  var data = UniVarProvider.data;
                  /*if (data is List<SongModel>) {
                    return ListTile(
                      leading: QueryArtworkWidget(
                        id: data[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget:  Icon(
                          Icons.music_note,
                          size: 32.w,
                        ),
                      ),
                      title: NormalText(
                        text: data[index].displayNameWOExt,
                      ),
                      subtitle: Text(data[index].artist ?? 'Unknown Artist'),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add functionality for sharing here
                            },
                            icon: const Icon(Icons.share),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add functionality for menu here
                            },
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      onTap: () {
                        playProvider.playSong(data[index], index);
                        uniVarProvider.addRecentSong(data[index]);
                      },
                    );
                  } else */
                  {
                    return SongTile(
                      song: widget.data[index],
                      onTap: () {
                        playProvider.playSong(widget.data[index], index);
                        // uniVarProvider.addRecentSong(widget.data[index]);
                      },
                    );
                  }
                },
                itemCount: widget.data.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 90.h,
          child: Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                    trackHeight: 1.5,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 5),
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4)),
                child: Slider(
                    thumbColor: AppColor.mainColor,
                    // activeColor: AppColor.sliderColor,
                    min: const Duration(seconds: 0).inSeconds.toDouble(),
                    max: playProvider.max,
                    value: playProvider.value,
                    onChanged: (newValue) {
                      playProvider.changeDurationToSecond(newValue.toInt());
                      newValue = newValue;
                    }),
              ),
              Container(
                // height: 100,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(playProvider.position),
                          Text(playProvider.duration)
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          iconSize: 20,
                          onPressed: () {
                            UniVarProvider.shuffleDataList();
                          },
                          padding: EdgeInsets.all(0),
                          icon: Icon(CupertinoIcons.shuffle),
                        ),
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: Icon(Icons.loop),
                        ),
                        IconButton(
                          onPressed: () {
                            if (playProvider.playIndex > 0) {
                              playProvider.playSong(
                                widget.data[playProvider.playIndex - 1],
                                playProvider.playIndex - 1,
                              );
                            } else {
                              /*Fluttertoast.showToast(
                                    msg: 'No previous song available',
                                    backgroundColor: Colors.grey,
                                  );*/
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 40.w,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: AppColor.mainColor,
                          radius: 25.w,
                          child: Transform.scale(
                            scale: 1.8,
                            child: IconButton(
                                onPressed: () {
                                  if (playProvider.isPlaying) {
                                    playProvider.audioPlayer.pause();
                                    playProvider.isPlaying = false;
                                  } else {
                                    playProvider.audioPlayer.play();
                                    playProvider.isPlaying = true;
                                  }
                                },
                                icon: playProvider.isPlaying
                                    ? Icon(Icons.pause)
                                    : Icon(
                                        Icons.play_arrow_rounded,
                                      )),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (playProvider.playIndex <
                                widget.data.length - 1) {
                              playProvider.playSong(
                                widget.data[playProvider.playIndex + 1],
                                playProvider.playIndex + 1,
                              );
                            } else {
                              /* Fluttertoast.showToast(
                                    msg: 'No next song available',
                                    backgroundColor: Colors.grey,
                                  );*/
                            }
                          },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // lyricPopup(
                            //     context, controller.playingModSong.value.id);
                          },
                          icon: Icon(Icons.lyrics),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget songResponseWidget() {
    var playProvider = Provider.of<PlaySongProvider>(context);

    return Column(children: [
       SizedBox(height: 50.h,),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: 300.h,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: playProvider.playingModSong != null
                      ? NetworkImage(playProvider.playingModSong.image.last.link)
                      : NetworkImage(appImage),
                ),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: _colorAnimation.value!,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            IconButton(
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
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: NormalText(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    text: playProvider.playingModSong != null
                        ? HtmlUnescape()
                            .convert(playProvider.playingModSong!.name)
                        : "SongName",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: NormalText(
                    text: playProvider.playingModSong != null
                        ? HtmlUnescape().convert(
                            playProvider.playingModSong!.primaryArtists)
                        : "artist",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: !playProvider.isHeartRed
                    ? Icon(
                        CupertinoIcons.heart,
                        size: 40,
                      )
                    : Icon(
                        CupertinoIcons.heart_fill,
                        size: 40,
                        color: Colors.red,
                      ),
                onPressed: () {
                  playProvider.isHeartRed = !playProvider.isHeartRed;
                },
              ),
            )
          ],
        ),
      ),
    ]);
  }

/*Widget ajdj() {
    return
      SlidingUpPanelWidget(
        controlHeight: 60.0,
        anchor: 0.4,
        minimumBound: minBound,
        upperBound: upperBound,
        panelController: panelController,
        onTap: () {
          if (SlidingUpPanelStatus.expanded == panelController.status) {
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              panelController.status == SlidingUpPanelStatus.dragging
                  ? Icon(Icons.keyboard_arrow_up)
                  : Icon(
                Icons.horizontal_rule,
                size: 30,
              ),
              Text('Next Up'),
              Flexible(
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var data = UniVarProvider.data;
                      return data is List<SongModel>
                          ? ListTile(
                        leading: QueryArtworkWidget(
                          id: widget.data[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Icon(
                            Icons.music_note,
                            size: 32,
                          ),
                        ),
                        title: NormalText(
                          text: widget.data[index].displayNameWOExt,
                        ),
                        NormalText: Text(widget.data[index].artist!),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Share.shareUri(Uri.parse(
                                //     widget.data![index].uri!));
                              },
                              icon: Icon(Icons.share),
                            ),
                            IconButton(
                              onPressed: () {
                                // PopupScreen.menuPopup(
                                //     context, widget.data![index]);
                              },
                              icon: Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                        onTap: () {
                          playProvider.playSong(
                              widget.data[index], index);
                          uniVarProvider
                              .addRecentSong(widget.data[index]);
                        },
                      )
                          : SongTile(
                          song: widget.data[index],
                          onTap: () {
                            playProvider.playSong(
                                widget.data[index], index);
                            uniVarProvider
                                .addRecentSong(widget.data[index]);
                          });
                    },
                    itemCount: widget.data.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
}*/

/* Widget songModelWidget() {
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(Dimension.padding(10)),
          height: Dimension.height(400),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimension.radius(20)),
            shape: BoxShape.rectangle,
          ),
          child: Obx(() {
            if (controller.playingModSong.value is SongResponse) {
              return CustomCard(
                leading: Image(
                  image: NetworkImage(
                      controller.playingModSong.value.downloadUrl.last.link),
                ),
              );
            } else if (controller.playingModSong.value is SongModel) {
              return QueryArtworkWidget(
                id: controller.playingModSong.value != null
                    ? controller.playingModSong.value!.id
                    : 0,
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: CircleAvatar(
                    radius: 150, backgroundImage: NetworkImage(appImage)),
                artworkBorder: BorderRadius.circular(Dimension.radius(10)),
                quality: 100,
              );
            } else {
              return CustomCard();
            }
          })),
      Text(
          controller.playingModSong.value != null
              ? controller.playingModSong.value!.displayNameWOExt
              : "SongName",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w600)),
      Text(
          controller.playingModSong.value != null
              ? "${controller.playingModSong.value!.artist}"
              : "artist",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: Dimension.fontSize(15), fontWeight: FontWeight.w300)),
    ]);
  }*/
}
