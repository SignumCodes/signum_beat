import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/const_var.dart';
import '../../../widgets/cards/playlistCard.dart';
import '../../tileDetails/playlist_detail.dart';


class TopPlaylist extends StatelessWidget {
  final List<dynamic> playlists;

  const TopPlaylist({super.key, required this.playlists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (c, index) {
          return PlaylistCard(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayListDetail(playlistId: playlists[index]['listid'],)));

            },
            title: NormalText(
              text: playlists[index]['listname'],
              overflow: TextOverflow.ellipsis,
            ),
            leading: Image(
              image: NetworkImage(
                playlists[index]['image']!.startsWith("http")
                    ? playlists[index]['image'].toString()
                    : appImage,
              ),
            ),
            // NormalText:NormalText(text: songs[i].primaryArtists,overflow: TextOverflow.ellipsis,),
          );
        },
      ),
    );
  }
}
