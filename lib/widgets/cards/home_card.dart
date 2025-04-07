import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/providers/playSong/playSongProvider.dart';
import 'package:signum_beat/utils/constants/const_var.dart';

import '../../api/jiosaavn/models/song.dart';

class HomeCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String type;
  final VoidCallback onTap;
  final Color backgroundColor;

  const HomeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.onTap,
    this.backgroundColor = Colors.white, required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: 160.w,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: _getIconForType(type),
                  ),
                ),
                if (type == 'playlist')
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 25.w,
                        width: 25.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(appImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
              ],
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconForType( String type ) {
    switch (type) {
      case 'album':
        return const Icon(
          Icons.album_outlined,
          color: Colors.white,
          size: 18,
        );
      case 'song':
        return Consumer<PlaySongProvider>(
          builder: (context, pr, ch) {
            if (pr.playingModSong == null || id == null || pr.playingModSong!.id.toString() != id) {
              return const Icon(
                Icons.play_arrow,
                color: Colors.white,
              );
            } else {
              return const Icon(
                Icons.bar_chart,
                color: Colors.white,
              );
            }
          },
        );
      case 'playlist':
        return const Icon(
          Icons.queue_music_outlined,
          color: Colors.white,
        );
      default:
        return const Icon(
          Icons.music_note,
          color: Colors.white,
        );
    }
  }
}