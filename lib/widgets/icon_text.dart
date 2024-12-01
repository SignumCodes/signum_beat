import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? fontSize;
  final double? iconSize;
  final Color ?color;
  final Function()? onTap;
  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.fontSize,
    this.iconSize,
    this.color,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading:  Icon(icon),
      title: Text(text,style: TextStyle(
          color: color,fontSize: fontSize
      ),),
    );
  }
}
