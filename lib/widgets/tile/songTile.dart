import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../api/jiosaavn/models/song.dart';
import '../popup/song_detail_popup.dart';

class SongTile extends StatelessWidget {
  final SongResponse song;
  Function() onTap;
  final bool? inSongDetails;
  SongTile({
    super.key,
    required this.song,
    required this.onTap, this.inSongDetails= false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ListTile(
        onTap: onTap,
        leading: Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Image(
              image: NetworkImage(
                  song.image!.first.link)),
        ),
        title: Text(
          HtmlUnescape()
              .convert(song.name.toString()),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(song.primaryArtists,
            overflow: TextOverflow.ellipsis),
        trailing: Wrap(
          children: [
            inSongDetails==false? IconButton(
                onPressed: (){
                  songDetailPopup(context,song );
                },
                icon: Icon(Icons.more_vert)
            ):SizedBox(),
            // Image.asset('assets/icons/icons8_audio_wave.gif')
          ],
        ),
      )
    );
  }
}
