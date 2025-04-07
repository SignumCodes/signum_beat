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
  final playSongProvider = Provider.of<PlaySongProvider>(context, listen: false);

  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: 500,
          height: 900,
          child: Stack(
            children: [
              Positioned(
                top: 80,
                child: Column(
                  children: [
                    Container(
                      height: 500, // Increased height
                      width: 370,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // More rounded corners
                        color: Theme.of(context).cardColor.withOpacity(0.9), // Slight transparency
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 90), // Adjusted for image overlap
                          Column(
                            children: [
                              Text(
                                song.name.toString(),
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                song.primaryArtists,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildStyledIconText(
                                    context,
                                    icon: CupertinoIcons.play_circle_fill,
                                    text: 'Play now',
                                    onTap: () {
                                      playSongProvider.playSong(song, 0);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: Icons.queue_music_rounded,
                                    text: 'Play next',
                                    onTap: () {
                                      UniVarProvider.data.cast<SongResponse>().removeWhere((SongResponse son) {
                                        return son.id == song.id;
                                      });
                                      UniVarProvider.data.insert(playSongProvider.playIndex+1, song);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: CupertinoIcons.heart_circle_fill,
                                    text: 'Mark to Favourite',
                                    onTap: () {
                                      // Favorite implementation
                                    },
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: CupertinoIcons.music_note_list,
                                    text: 'Add to Playlist',
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: Icons.playlist_add_rounded,
                                    text: 'Add to Queue',
                                    onTap: (){
                                      UniVarProvider.data.add(song);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: CupertinoIcons.cloud_download_fill,
                                    text: 'Download',
                                    onTap: () {
                                      var songMetaData = SongMetadata(
                                          fileName: song.name ?? 'song',
                                          filePath: '',
                                          artist: song.primaryArtists,
                                          album: song.album.name,
                                          songThumbnailUrl: song.image!.last.link,
                                          downloadUrl: song.downloadUrl!.last.link
                                      );
                                      downloadProvider.downloadSong(songMetaData);
                                    },
                                  ),
                                  _buildStyledIconText(
                                    context,
                                    icon: Icons.share_rounded,
                                    text: 'Share',
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 60,
                          width: 370,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      song.image!.last.link,
                      width: 170,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
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
    barrierDismissible: true,
  );
}

// Helper method for consistent styling of icon texts
Widget _buildStyledIconText(
    BuildContext context, {
      required IconData icon,
      required String text,
      VoidCallback? onTap,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor.withOpacity(0.5),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}