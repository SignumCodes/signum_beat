import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signum_beat/screen/tileDetails/artist_detail.dart';
import 'package:signum_beat/widgets/text_widget/normal_text.dart';

class RecommendedArtist extends StatelessWidget {
  final List<dynamic> artist;

  const RecommendedArtist({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: artist.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildArtistCard(context, index);
        },
      ),
    );
  }

  Widget _buildArtistCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArtistDetail(
                  artistId: artist[index]['artistid'],
                )
            )
        );
      },
      child: Container(
        width: 140.w,
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
          alignment: Alignment.center,
          children: [
            // Subtle background effect
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated profile image with glowing effect
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                    image: DecorationImage(
                      image: NetworkImage(
                        artist[index]['image'] ?? 'https://via.placeholder.com/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Spacer
                SizedBox(height: 5.h),

                // Artist name with modern typography
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    artist[index]['name'],
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
                    textAlign: TextAlign.center,
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