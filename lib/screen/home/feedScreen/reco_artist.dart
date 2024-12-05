import 'package:signum_beat/screen/tileDetails/artist_detail.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/albumProvider.dart';
import '../../../utils/constants/const_var.dart';
import '../../../widgets/custom_card.dart';
import '../../tileDetails/albumDetail.dart';

class RecommendedArtist extends StatelessWidget {
  final List<dynamic> artist;

  const RecommendedArtist({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        physics: const BouncingScrollPhysics(),
        itemCount: artist.length,
        itemBuilder: (context, index) {
          return CustomCard(
            title: NormalText(
              text: artist![index]['name'],
              overflow: TextOverflow.ellipsis,
            ),
            leading: Image(
              image: artist[index]['image']
                  .toString()
                  .startsWith("http")
                  ? NetworkImage(artist[index]['image'])
                  : NetworkImage(appImage),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80)),
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ArtistDetail(artistId: artist[index]['artistid'],)));

            },
          );
        },
      ),
    );
  }
}
