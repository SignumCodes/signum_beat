import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import '../../../utils/constants/const_var.dart';
import '../../../widgets/cards/home_card.dart';
import '../../../widgets/cards/playlistCard.dart';
import '../../tileDetails/playlist_detail.dart';

class TopPlaylist extends StatelessWidget {
  final List<dynamic> playlists;

  const TopPlaylist({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const NormalText(
            text: 'Top Playlists',

          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: playlists.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemBuilder: (context, index) {
              return HomeCard(
                type: 'playlist',
               imageUrl: playlists[index]['image']!.startsWith("http")
                  ? playlists[index]['image'].toString()
                  : appImage,
                title:  playlists[index]['listname'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayListDetail(
                        playlistId: playlists[index]['listid'],
                      ),
                    ),
                  );
                }, id: playlists[index]['listid'].toString(),
              );


            },
          ),
        ),
      ],
    );
  }
}