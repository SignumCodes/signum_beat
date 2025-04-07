import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/albumProvider.dart';
import '../../../widgets/text_widget/normal_text.dart';
import '../../tileDetails/albumDetail.dart';

class NewAlbum extends StatelessWidget {
  final List<dynamic> album;

  const NewAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190.h,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 5.h),
        itemCount: album.length,
        separatorBuilder: (context, index) => SizedBox(width: 16.w),
        itemBuilder: (context, index) {
          return _buildAlbumCard(context, index);
        },
      ),
    );
  }

  Widget _buildAlbumCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigateToAlbumDetails(context, index),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Image with enhanced styling
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network(
                    album[index]['image'],
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150.h,
                        color: Theme.of(context).dividerColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.h,
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

            // Album Details with improved typography
            Padding(
              padding: EdgeInsets.symmetric(horizontal :12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album[index]['title'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAlbumDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AlbumProvider(id: album[index]['albumid']),
          child: AlbumDetails(albumId: album[index]['albumid']),
        ),
      ),
    );
  }
}