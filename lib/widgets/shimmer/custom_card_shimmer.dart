import 'package:signum_beat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomCardShimmer extends StatelessWidget {
  final double size;
  const CustomCardShimmer({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor.withOpacity(0.2),
        highlightColor: Colors.grey.shade700,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context,index){
            return SizedBox(
              height: size+40,
              width: size,

              child: Card(color: Colors.red,),
            );
          },
        )
      ),
    );
  }
}
