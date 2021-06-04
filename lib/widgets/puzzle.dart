import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/coord.dart';

class Puzzle extends StatelessWidget {
  final Coord coord;
  final double puzzleSize;
  final int puzzleNumber;

  Puzzle({
    Key? key,
    required this.coord,
    required this.puzzleSize,
    required this.puzzleNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: coord.y,
      left: coord.x,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: puzzleSize,
          height: puzzleSize,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConsts.boardBorderColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${puzzleNumber}',
              style: TextStyle(
                color: ColorConsts.boardBgColor,
                fontSize: 50,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(-2, -2),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
