import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TitlePlaceholder extends StatelessWidget {
  final double width;

  const TitlePlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor.withOpacity(0.2),
      highlightColor: Colors.grey.shade700,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }
}