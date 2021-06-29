import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/constants/icons_consts.dart';
import 'package:puzzlers/widgets/custom_icon.dart';
import 'package:puzzlers/widgets/custom_text.dart';

typedef OnTap = void Function();

class CustomNavigationButton extends StatelessWidget {
  final OnTap onTap;

  CustomNavigationButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIcon(
            icon: IconConsts.back,
            iconSize: 40,
            color: ColorConsts.boardBorderColor,
            blurRadius: 2.0,
            shadowOffset1: 0.3,
            shadowOffset2: 0.5,
            shadowOffset3: 0.7,
          ),
          CustomText(
            title: 'Back',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Candal',
            blurRadius: 2.0,
            shadowOffset1: 0.3,
            shadowOffset2: 0.5,
            shadowOffset3: 0.7,
          ),
        ],
      ),
    );
  }
}
