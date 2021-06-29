import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;
  final double shadowOffset1;
  final double shadowOffset2;
  final double shadowOffset3;
  final double blurRadius;

  const CustomIcon({
    required this.icon,
    this.iconSize = 24.0,
    this.color = const Color(0xFFFFF3E0),
    this.shadowOffset1 = 0.0,
    this.shadowOffset2 = 0.0,
    this.shadowOffset3 = 0.0,
    this.blurRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedIcon(
        icon,
        size: iconSize,
        color: color,
        shadows: [
          BoxShadow(
            blurRadius: blurRadius,
            color: Colors.black,
            offset: Offset(shadowOffset1, shadowOffset1),
          ),
          BoxShadow(
            blurRadius: blurRadius,
            color: Colors.black,
            offset: Offset(shadowOffset2, shadowOffset2),
          ),
          BoxShadow(
            blurRadius: blurRadius,
            color: Colors.black,
            offset: Offset(shadowOffset3, shadowOffset3),
          ),
        ],
      ),
    );
  }
}
