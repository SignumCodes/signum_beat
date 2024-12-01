import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color lineColor;
  final double lineHeight;

  CustomAppBar({
    required this.title,
    this.lineColor = Colors.black,
    this.lineHeight = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      elevation: 0, // Remove the default shadow under the AppBar
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + lineHeight);
}