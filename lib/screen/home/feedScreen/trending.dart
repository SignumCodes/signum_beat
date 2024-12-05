import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/api/jiosaavn/jiosaavn.dart';
import 'package:signum_beat/main.dart';
import 'package:signum_beat/widgets/cards/playlistCard.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/albumProvider.dart';
import '../../../providers/playSong/playSongProvider.dart';
import '../../../widgets/custom_card.dart';
import '../../tileDetails/albumDetail.dart';
import '../../tileDetails/playlist_detail.dart';

class NewTrending extends StatelessWidget {
  final List<dynamic> newTrending;
   NewTrending({super.key, required this.newTrending});
  final  jio = JioSaavnClient();
  @override
  Widget build(BuildContext context) {

    final playSongProvider = Provider.of<PlaySongProvider>(context);

    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newTrending.length,
        itemBuilder: (c, i) {
          var data = newTrending[i];
          return newTrending[i]['type'] == 'album'
              ? CustomCard(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) =>
                              AlbumProvider(id: data['details']['albumid']),
                          child:
                              AlbumDetails(albumId: data['details']['albumid']),
                        ),
                      ),
                    );
                  },
                  title: NormalText(
                    text: data['details']['title'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Image(image: NetworkImage(data['details']['image'])),
                )
              : newTrending[i]['type'] == 'song'
                  ? CustomCard(
                      onTap: () async {
                        var song = await jio.songs
                            .detailsById(data['details']['id']);
                        playSongProvider.playSong(song, 0);
                      },
                      title: NormalText(
                        text: data['details']['song'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading:
                          Image(image: NetworkImage(data['details']['image'])),
                    )
                  : data['type'] == 'playlist'
                      ? PlaylistCard(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayListDetail(playlistId: data['details']['listid'],)));

                          },
                          title: NormalText(
                            text: data['details']
                            ['listname'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Image(
                              image: NetworkImage(data['details']['image'])),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        )
                      : Container();
        },
      ),
    );
  }
}
