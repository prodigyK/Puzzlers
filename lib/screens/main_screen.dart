import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/screens/play_screen.dart';

enum BoardSize {
  SMALL,
  CLASSIC,
  LARGE,
  PRO,
}

class MainScreen extends StatelessWidget {
  final buttonBgImage = 'assets/textures/wood_09.jpg';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/textures/wood_02.jpg"),
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
                Container(
                  width: 150,
                  height: 150,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(blurRadius: 3)]),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 76,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade600,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
                            image: DecorationImage(
                              image: AssetImage('assets/textures/wood_04.jpg'),
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.repeat,
                              matchTextDirection: true,
                              colorFilter: const ColorFilter.mode(
                                Colors.brown,
                                BlendMode.saturation,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '24',
                              style: GoogleFonts.candal(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: ColorConsts.boardBgColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 75,
                        left: 0,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade200,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25)),
                            image: DecorationImage(
                              image: AssetImage('assets/textures/wood_02.jpg'),
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.repeat,
                              matchTextDirection: true,
                              colorFilter: const ColorFilter.mode(
                                Colors.brown,
                                BlendMode.saturation,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '8',
                              style: GoogleFonts.candal(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: ColorConsts.boardBgColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 75,
                        left: 75,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade800,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(25)),
                            image: DecorationImage(
                              image: AssetImage('assets/textures/wood_05.jpg'),
                              fit: BoxFit.contain,
                              repeat: ImageRepeat.repeat,
                              matchTextDirection: true,
                              colorFilter: const ColorFilter.mode(
                                Colors.brown,
                                BlendMode.saturation,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '35',
                              style: GoogleFonts.candal(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: ColorConsts.boardBgColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade400,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                          image: DecorationImage(
                            image: AssetImage(buttonBgImage),
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.repeat,
                            matchTextDirection: true,
                            colorFilter: const ColorFilter.mode(
                              Colors.brown,
                              BlendMode.screen,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '15',
                            style: GoogleFonts.candal(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: ColorConsts.boardBgColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                _buildMenuItem(
                  context: context,
                  title: 'Pro  6 x 6',
                  boardSize: BoardSize.PRO,
                ),
                SizedBox(height: 20),
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
        color: Colors.brown.shade300.withOpacity(0.6),
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

  Widget _buildMenuItem(
      {required BuildContext context, required String title, BoardSize boardSize = BoardSize.CLASSIC}) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.06,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(buttonBgImage),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                  matchTextDirection: true,
                  colorFilter: const ColorFilter.mode(
                    Colors.brown,
                    BlendMode.screen,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: _textWidget2(
                  title: '$title',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(25)),
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
                    case BoardSize.PRO:
                      Navigator.of(context).pushNamed(PlayScreen.routeName, arguments: {'boardSize': 6});
                      break;
                  }
                },
                highlightColor: Colors.brown.shade300.withOpacity(0.5),
              ),
            ),
          ),
        ],
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

  Text _textWidget2(
      {String? title, double? fontSize, FontWeight? fontWeight, double blurRadius = 1.0, double shadowOffset1 = 0.7}) {
    return Text(
      '$title',
      style: GoogleFonts.candal(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: ColorConsts.boardBgColor,
        shadows: [
          BoxShadow(
            color: Colors.black,
            blurRadius: blurRadius,
            offset: Offset(shadowOffset1, shadowOffset1),
          ),

        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
