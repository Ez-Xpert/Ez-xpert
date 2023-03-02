import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dimensions.dart';

class PoppinsAddText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? wordSpacing;
  final double? height;
  final double? letterSpacing;
  final TextOverflow? textOverflow;
  const PoppinsAddText(
      {Key? key,
      required this.text,
      this.fontSize = 0,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.maxLines,
      this.wordSpacing,
      this.letterSpacing,
      this.textOverflow, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
      style: GoogleFonts.poppins(
          fontSize: fontSize == 0 ? AddSize.font14 : fontSize,
          height: height,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          color: color,
          fontWeight: fontWeight),
    );
  }
}
