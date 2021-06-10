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
                // SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDecoreContainer(title: '8'),
                    SizedBox(width: 10),
                    _buildDecoreContainer(title: '15', fontSize: 60, size: 110),
                    SizedBox(width: 10),
                    _buildDecoreContainer(title: '24'),
                  ],
                ),
                SizedBox(height: 20),
                _textWidget(
                  title: 'Puzzlers',
                  fontSize: 75,
                  fontWeight: FontWeight.w900,
                  shadowOffset1: 0.5,
                  shadowOffset2: 1.0,
                  shadowOffset3: 1.5,
                  blurRadius: 6,
                ),
                SizedBox(height: 40),
                _buildMenuItem(
                  context: context,
                  title: 'Small  3 x 3',
                  boardSize: BoardSize.SMALL,
                ),
                SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  title: 'Classic  4 x 4',
                  boardSize: BoardSize.CLASSIC,
                ),
                SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  title: 'Large  5 x 5',
                  boardSize: BoardSize.LARGE,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecoreContainer({required String title, double size = 80, double fontSize = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: ColorConsts.boardBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.brown.shade300.withOpacity(0.7),
      ),
      child: Center(
        child: _textWidget(
          title: '$title',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          shadowOffset1: 0.5,
          shadowOffset2: 1.0,
          shadowOffset3: 1.5,
          blurRadius: 6,
        ),
      ),
    );
  }

  InkWell _buildMenuItem(
      {required BuildContext context,
      required String title,
      BoardSize boardSize = BoardSize.CLASSIC}) {
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
        height: size.height * 0.09,
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: ColorConsts.boardBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.brown.shade300.withOpacity(0.3),
        ),
        child: Center(
          child: _textWidget(
            title: '$title',
            fontSize: 35,
            fontWeight: FontWeight.w400,
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
      Color? color,
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
