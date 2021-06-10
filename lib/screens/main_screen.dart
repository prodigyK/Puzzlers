import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/screens/play_screen.dart';

enum BoardSize {
  SMALL,
  CLASSIC,
  LARGE,
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/textures/wood_07.jpg"),
          fit: BoxFit.contain,
          repeat: ImageRepeat.repeat,
          colorFilter: const ColorFilter.mode(
            Colors.white60,
            BlendMode.softLight,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _textWidget(
                  title: 'Puzzlers',
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  shadowOffset1: 0.5,
                  shadowOffset2: 1.0,
                  shadowOffset3: 1.5,
                  blurRadius: 6,
                ),
                SizedBox(height: 40),
                buildMenuItem(context: context, title: 'Small  3 x 3', boardSize: BoardSize.SMALL),
                SizedBox(height: 20),
                buildMenuItem(context: context, title: 'Classic  4 x 4', boardSize: BoardSize.CLASSIC),
                SizedBox(height: 20),
                buildMenuItem(context: context, title: 'Large  5 x 5', boardSize: BoardSize.LARGE),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell buildMenuItem(
      {required BuildContext context, required String title, BoardSize boardSize = BoardSize.CLASSIC}) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        switch (boardSize) {
          case BoardSize.SMALL:
            Navigator.of(context).pushNamed(PlayScreen.routeName, arguments: {'boardSize': 3});
            break;
          case BoardSize.CLASSIC:
            Navigator.of(context).pushNamed(PlayScreen.routeName, arguments: {'boardSize': 4});
            break;
          case BoardSize.LARGE:
            Navigator.of(context).pushNamed(PlayScreen.routeName, arguments: {'boardSize': 5});
            break;
        }
      },
      overlayColor: MaterialStateProperty.all(ColorConsts.boardBorderColor),
      splashColor: ColorConsts.boardBorderColor,
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.1,
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: ColorConsts.boardBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.brown.shade300.withOpacity(0.3),
        ),
        child: Center(
          child: _textWidget(
            title: '$title',
            fontSize: 40,
            fontWeight: FontWeight.w900,
            shadowOffset1: 0.5,
            shadowOffset2: 1.0,
            shadowOffset3: 1.5,
            blurRadius: 3,
          ),
        ),
      ),
    );
  }

  Text _textWidget(
      {String? title,
        double? fontSize,
        FontWeight? fontWeight,
        double blurRadius = 1.0,
        double shadowOffset1 = 0.3,
        double shadowOffset2 = 0.5,
        double shadowOffset3 = 0.7}) {
    return Text(
      '$title',
      style: GoogleFonts.candal(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: ColorConsts.boardBorderColor,
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
    );
  }
}
