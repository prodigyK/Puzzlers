import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double blurRadius;
  final double shadowOffset1;
  final double shadowOffset2;
  final double shadowOffset3;
  final String fontFamily;
  TextStyle? textStyle;

  CustomText({
    required this.title,
    required this.fontSize,
    this.color = const Color(0xFF6D4C41),
    this.fontWeight = FontWeight.normal,
    this.fontFamily = 'Baloo Tammudu',
    this.blurRadius = 0.0,
    this.shadowOffset1 = 0.0,
    this.shadowOffset2 = 0.0,
    this.shadowOffset3 = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title',
        style: GoogleFonts.getFont(fontFamily).copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          shadows: [
            BoxShadow(
              color: Colors.black,
              blurRadius: blurRadius,
              offset: Offset(shadowOffset1, shadowOffset1),
            ),
            BoxShadow(
              color: Colors.black,
              blurRadius: blurRadius,
              offset: Offset(shadowOffset2, shadowOffset2),
            ),
            BoxShadow(
              color: Colors.black,
              blurRadius: blurRadius,
              offset: Offset(shadowOffset3, shadowOffset3),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
