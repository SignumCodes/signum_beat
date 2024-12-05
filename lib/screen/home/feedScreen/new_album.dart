import 'package:signum_beat/main.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/albumProvider.dart';
import '../../../widgets/custom_card.dart';
import '../../tileDetails/albumDetail.dart';

class NewAlbum extends StatelessWidget {
  final List<dynamic> album;

  const NewAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: album.length,
        itemBuilder: (c, index) {
          return CustomCard(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider(
                        create: (_) => AlbumProvider(
                            id: album[index]
                            ['albumid']),
                        child: AlbumDetails(
                            albumId: album[index]
                            ['albumid']),
                      ),
                ),
              );
            },
            title: NormalText(
              text: album[index]['title'],
              overflow: TextOverflow.ellipsis,
            ),
            leading: Image(
                image: NetworkImage(
                    album[index]['image'])),
          );
        },
      ),
    );
  }
}
