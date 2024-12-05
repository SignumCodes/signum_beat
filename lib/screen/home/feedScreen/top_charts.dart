import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/main.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import 'package:flutter/material.dart';

import '../../../widgets/cards/playlistCard.dart';
import '../../tileDetails/playlist_detail.dart';

class TopCharts extends StatelessWidget {
  final List<dynamic> chart;

  const TopCharts({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chart.length,
        itemBuilder: (context, index) {

          return PlaylistCard(
            title: NormalText(
              text: chart[index]['title'],
              overflow: TextOverflow.ellipsis,
            ),
            leading: Image(
                image: NetworkImage(chart[index]['image'])),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayListDetail(playlistId: chart[index]['id'],)));
            },
          );
        },
      ),
    );
  }
}
