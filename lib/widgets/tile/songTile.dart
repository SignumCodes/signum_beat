import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../api/jiosaavn/models/song.dart';
import '../popup/song_detail_popup.dart';

class SongTile extends StatelessWidget {
  final SongResponse song;
  final Function() onTap;
  final bool? inSongDetails;
  final int? index;

  const SongTile({
    super.key,
    required this.song,
    required this.onTap,
    this.inSongDetails = false,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(song.image!.last.link),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {
                // This is a placeholder for error handling
                // In real implementation, you might want to use a default image
              },
            ),
          ),
        ),
        title: Text(
          HtmlUnescape().convert(song.name.toString()),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.primaryArtists ?? 'Unknown Artist',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            songDetailPopup(context, song);

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),
      ),
      ),
    );
  }
}