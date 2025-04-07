import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';
import '../../../widgets/cards/home_card.dart';
import '../../tileDetails/playlist_detail.dart';

class TopCharts extends StatelessWidget {
  final List<dynamic> chart;

  const TopCharts({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chart.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return HomeCard(
            id: chart[index]['id'].toString(),
            type: 'playlist',
            imageUrl: chart[index]['image'],
            title:  chart[index]['title'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayListDetail(
                    playlistId: chart[index]['id'],
                  ),
                ),
              );
            },
          );
          return _buildChartCard(context, index);
        },
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayListDetail(
              playlistId: chart[index]['id'],
            ),
          ),
        );
      },
      child: Container(
        width: 180.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            )
          ],
        ),
        child: Stack(
          children: [
            // Background gradient effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
                    center: Alignment.topRight,
                    radius: 1.5,
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist Image with overlay
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        chart[index]['image'],
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 160.h,
                            color: Theme.of(context).dividerColor,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160.h,
                            color: Theme.of(context).dividerColor,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 50.sp,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Theme.of(context).cardColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Playlist Title
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Text(
                    chart[index]['title'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
