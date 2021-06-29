import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/widgets/custom_text.dart';

class PuzzleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(blurRadius: 2)],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 76,
            child: _buildContainer(
              title: '24',
              fontSize: 30,
              imagePath: 'assets/textures/wood_04.jpg',
              width: 75,
              height: 75,
              borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
            ),
          ),
          Positioned(
            top: 75,
            left: 0,
            child: _buildContainer(
                title: '8',
                fontSize: 30,
                imagePath: 'assets/textures/wood_02.jpg',
                width: 75,
                height: 75,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25))
            ),
          ),
          Positioned(
            top: 75,
            left: 75,
            child: _buildContainer(
                title: '36',
                fontSize: 30,
                imagePath: 'assets/textures/wood_05.jpg',
                width: 75,
                height: 75,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(25))
            ),
          ),
          _buildContainer(
            title: '15',
            fontSize: 60,
            imagePath: 'assets/textures/wood_09.jpg',
            width: 90,
            height: 90,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
            colorFilter: const ColorFilter.mode(Colors.brown, BlendMode.screen),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({
    required double width,
    required double height,
    required String imagePath,
    required String title,
    required double fontSize,
    required BorderRadiusGeometry? borderRadius,
    ColorFilter colorFilter = const ColorFilter.mode(
      Colors.brown,
      BlendMode.saturation,
    ),
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.brown.shade600,
        borderRadius: borderRadius,//BorderRadius.only(topRight: Radius.circular(25)),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
          repeat: ImageRepeat.repeat,
          matchTextDirection: true,
          colorFilter: colorFilter,
        ),
      ),
      child: CustomText(
        title: '$title',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Candal',
        color: ColorConsts.textColor,
        blurRadius: 2.0,
        shadowOffset1: 0.3,
      ),
    );
  }

}
