import 'package:signum_beat/screen/tileDetails/song_detail.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../api/jiosaavn/models/song.dart';
import '../../providers/download/download_provider.dart';
import '../../providers/playSong/playSongProvider.dart';
import '../../providers/playSong/universalVariableProvider.dart';
import '../custom_card.dart';
import '../icon_text.dart';

songDetailPopup(BuildContext context, SongResponse song) async {
  var downloadProvider = Provider.of<DownloadProvider>(context, listen: false);
  final playSongProvider =
      Provider.of<PlaySongProvider>(context, listen: false);
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: 500, // Set your desired width
          height: 900, // Set your desired height
          child: Stack(
            children: [
              Positioned(
                top: 80,
                child: Column(
                  children: [
                    Container(
                      height: 450,
                      width: 370,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Column(
                            children: [
                              NormalText(
                                  text: song.name.toString(),
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis),
                              NormalText(
                                text: song.primaryArtists,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconText(
                                    text: 'Play now',
                                    icon: CupertinoIcons.play,
                                    onTap: () {
                                      playSongProvider.playSong(song, 0);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconText(
                                      text: 'Play next',
                                      icon: Icons.queue_play_next,
                                      onTap: () {
                                        UniVarProvider.data.cast<SongResponse>().removeWhere((SongResponse son) {
                                          return son.id == song.id;
                                        });
                                        UniVarProvider.data.insert(playSongProvider.playIndex+1, song);
                                        Navigator.pop(context);
                                      }),
                                  IconText(
                                    text: 'Mark to Favourite',
                                    icon: CupertinoIcons.heart,
                                    onTap: () {
                                      // UniVar.favouriteSong.add(song);
                                      // Fluttertoast.showToast(msg: 'Added to favourite');
                                    },
                                  ),
                                  IconText(
                                    text: 'Add to Playlist',
                                    icon: CupertinoIcons.music_note_list,
                                  ),
                                  IconText(
                                    text: 'Add to Queue',
                                    icon: Icons.playlist_add_rounded,
                                    onTap: (){
                                      UniVarProvider.data.add(song);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  IconText(
                                      text: 'Download',
                                      icon: CupertinoIcons.arrow_down_to_line,
                                      onTap: () {
                                        var songMetaData = SongMetadata(
                                            fileName: song.name ?? 'song',
                                            filePath: '',
                                            artist: song.primaryArtists,
                                            album: song.album.name,
                                            songThumbnailUrl:
                                                song.image!.last.link,
                                            downloadUrl:
                                                song.downloadUrl!.last.link);
                                        downloadProvider
                                            .downloadSong(songMetaData);
                                        // playSongProvider.downloadAndTagSong(song.downloadUrl!.last.link,song.image!.last.link, fileName: '', artist: '', album: '');
                                      }),
                                  IconText(
                                    text: 'Share',
                                    icon: Icons.share,
                                  ),
                                  IconText(
                                    text: 'Detail',
                                    icon: Icons.details,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  SongDetails(song: song)));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          width: 370,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).cardColor),
                          child: Center(
                            child: NormalText(
                              text: "Cancel",
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: 100,
                  child: CustomCard(
                    leading: Image(
                      image: NetworkImage(song.image!.last.link),
                    ),
                  )),
            ],
          ),
        ),
      ),
    ),
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      const begin = Offset(1, 1);
      const end = Offset(0, 0.3);
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierLabel: 'Dismiss',
    // Provide a non-null value for barrierLabel
    barrierDismissible: true,
  );
}
