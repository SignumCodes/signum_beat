import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  const NormalText(
      {super.key,
      this.fontSize,
      required this.text,
      this.color,
      this.softWrap,
      this.fontWeight,
      this.overflow,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: GoogleFonts.lato(
          fontSize: fontSize??12, color: color, fontWeight: fontWeight),
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
