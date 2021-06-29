import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/widgets/custom_icon.dart';
import 'package:puzzlers/widgets/custom_text.dart';

const buttonBgImage = 'assets/textures/wood_09.jpg';
const buttonRadius = 25.0;
const buttonBlur = 5.0;
const buttonElevation = 3.0;
const buttonShadow = 1.0;
const Color buttonColor = Colors.brown;
const BlendMode buttonBlendMode = BlendMode.screen;

typedef OnTap = void Function();

class CustomDecoratedButton extends StatelessWidget {
  final OnTap onTap;
  final double width;
  final double height;
  final IconData icon;
  final double iconSize;
  final String title;

  const CustomDecoratedButton({
    required this.onTap,
    required this.width,
    required this.height,
    required this.icon,
    required this.iconSize,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(buttonRadius)),
                image: DecorationImage(
                  image: AssetImage(buttonBgImage),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                  colorFilter: const ColorFilter.mode(
                    buttonColor,
                    buttonBlendMode,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade900,
                    blurRadius: 5,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomIcon(
                    icon: icon,
                    iconSize: iconSize, // 16
                  ),
                  if (title.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(height: 5),
                        CustomText(
                          title: '$title',
                          fontSize: 16,
                          fontFamily: 'Candal',
                          fontWeight: FontWeight.bold,
                          color: ColorConsts.textColor,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                onTap: onTap,
                highlightColor: Colors.brown.shade300.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
