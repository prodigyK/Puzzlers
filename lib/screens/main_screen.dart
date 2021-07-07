import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/board.dart';
import 'package:puzzlers/screens/play_screen.dart';
import 'package:puzzlers/widgets/custom_text.dart';
import 'package:puzzlers/widgets/puzzle_logo.dart';

enum BoardSize {
  SMALL,
  CLASSIC,
  LARGE,
  PRO,
}

const buttonBgImage = 'assets/textures/wood_09.jpg';

class MainScreen extends StatelessWidget {
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
                PuzzleLogo(),
                SizedBox(height: 20),
                CustomText(
                  title: 'Puzzlers',
                  fontSize: 60,
                  fontFamily: 'Candal',
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
                  boardSize: Board.THREE,
                ),
                SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  title: 'Classic  4 x 4',
                  boardSize: Board.FOUR,
                ),
                SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  title: 'Large  5 x 5',
                  boardSize: Board.FIVE,
                ),
                SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  title: 'Pro  6 x 6',
                  boardSize: Board.SIX,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({required BuildContext context, required String title, Board boardSize = Board.FOUR}) {
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
              child: CustomText(
                title: '$title',
                fontSize: 25,
                fontWeight: FontWeight.w400,
                fontFamily: 'Candal',
                color: ColorConsts.textColor,
                blurRadius: 1.0,
                shadowOffset1: 0.3,
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
                  int board = boardSize.value;
                  Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.of(context).pushNamed(PlayScreen.routeName, arguments: {'boardSize': board});
                  });
                },
                highlightColor: Colors.brown.shade300.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
