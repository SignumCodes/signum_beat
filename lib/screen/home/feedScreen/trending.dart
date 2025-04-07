import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../api/jiosaavn/jiosaavn.dart';
import '../../../providers/albumProvider.dart';
import '../../../providers/playSong/playSongProvider.dart';
import '../../../widgets/cards/home_card.dart';
import '../../tileDetails/albumDetail.dart';
import '../../tileDetails/playlist_detail.dart';

class NewTrending extends StatelessWidget {
  final List<dynamic> newTrending;
  final jio = JioSaavnClient();

  NewTrending({super.key, required this.newTrending});

  Widget _buildTrendingItem(BuildContext context, dynamic data) {
    final playSongProvider = Provider.of<PlaySongProvider>(context, listen: false);

    // Common styling for all items
    Widget _buildItemContent({
      required String imageUrl,
      required String title,
      required VoidCallback onTap,
      Color? backgroundColor,
    }) {
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
                  backgroundColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1)
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6)
                )
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with overlay
              Stack(
                children: [
                  Container(
                    height: 120.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3)
                            ]
                        )
                    ),
                  ),
                  // Optional play/view icon
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        _getIconForType(data['type']),
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
              // Title
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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

    // Handle different types of trending items
    switch (data['type']) {
      case 'album':
        return HomeCard(
          id: data['details']['albumid'].toString(),
          type: data['type'],
          imageUrl: data['details']['image'],
          title: data['details']['title'],
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => AlbumProvider(id: data['details']['albumid']),
                  child: AlbumDetails(albumId: data['details']['albumid']),
                ),
              ),
            );
          },
        );

      case 'song':
        return HomeCard(
          id: data['details']['id'].toString(),
          type: data['type'],
          imageUrl: data['details']['image'],
          title: data['details']['song'],
          backgroundColor: Colors.green,
          onTap: () async {
            var song = await jio.songs.detailsById(data['details']['id']);
            playSongProvider.playSong(song, 0);
          },
        );

      case 'playlist':
        return HomeCard(
          type: data['type'],
          imageUrl: data['details']['image'],
          title: data['details']['listname'],
          backgroundColor: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayListDetail(
                  playlistId: data['details']['listid'],
                ),
              ),
            );
          }, id:  data['details']['listid'].toString(),
        );

      default:
        return SizedBox.shrink();
    }
  }

  // Helper method to get appropriate icon based on type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'album':
        return Icons.album_outlined;
      case 'song':
        return Icons.play_arrow_rounded;
      case 'playlist':
        return Icons.queue_music_outlined;
      default:
        return Icons.music_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: newTrending.length,
        itemBuilder: (context, index) {

         // return HomeCard(imageUrl: newTrending[index]['details']['image'], title:newTrending[index]['details']['listname'], type: newTrending[index]['type'], onTap: () {  },);
          return _buildTrendingItem(context, newTrending[index]);
        },
      ),
    );
  }

}