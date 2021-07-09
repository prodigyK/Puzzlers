import 'package:flutter/material.dart';
import 'package:puzzlers/models/device.dart';
import 'package:puzzlers/utils/screen_util.dart';
import 'package:puzzlers/widgets/custom_text.dart';

typedef MyFuncAction = void Function();
final String buttonImage = 'assets/textures/wood_09.jpg';

class CustomButton extends StatelessWidget {
  final String title;
  final MyFuncAction onPressed;
  final double bottomBoarder;
  final String fontFamily;
  final Color textColor;

  const CustomButton({
    required this.title,
    required this.onPressed,
    this.bottomBoarder = 0,
    this.fontFamily = 'Candal',
    this.textColor = const Color(0xFFFFF3E0),
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Device device = ScreenUtil.checkDevice(size.height);
    return Container(
      width: double.infinity,
      height: ScreenUtil.devicesHeight[device]!['button']!,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomBoarder),
                  bottomRight: Radius.circular(bottomBoarder),
                ),
                image: DecorationImage(
                  image: AssetImage(buttonImage),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                  colorFilter: const ColorFilter.mode(
                    Colors.brown,
                    BlendMode.screen,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: CustomText(
                title: '$title',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                blurRadius: 2.0,
                shadowOffset1: 0.5,
                color: textColor,
                fontFamily: fontFamily,
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(bottomBoarder)),
                onTap: onPressed,
                highlightColor: Colors.brown.shade300.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
