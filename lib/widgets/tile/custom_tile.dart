import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String artists;
  final String year;
  final String type;
  final String image;
  final String? count;
  final Function() onTap;

  const CustomTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.image,
    required this.artists,
    required this.year,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom leading image
            Container(
              width: 100.w, // Custom width
              height: 120.h, // Custom height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w), // Space between image and text
            // Title and other details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HtmlUnescape().convert(title),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],

                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        "Artists: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          artists,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[800],
                          ),
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        "Type: ",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[800],
                          ),
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Year: $year",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Visibility(
                    visible: count!=null,
                    child: Text(
                      "$count Songs",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
