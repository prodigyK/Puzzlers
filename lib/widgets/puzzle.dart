import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/board.dart';
import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/providers/update_puzzles_provider.dart';
import 'package:puzzlers/widgets/custom_text.dart';

class Puzzle extends StatefulWidget {
  Coord coord;
  final double puzzleSize;
  final int puzzleNumber;
  final Function func;
  bool isShuffled = false;
  final int boardSize;
  final Function updateTaps;
  final Function startTimer;

  Puzzle({
    Key? key,
    required this.coord,
    required this.puzzleSize,
    required this.puzzleNumber,
    required this.func,
    required this.boardSize,
    required this.updateTaps,
    required this.startTimer,
  }) : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  double x = -1;
  double y = -1;
  Map<Board, double> fontSizes = {
    Board.THREE: 70,
    Board.FOUR: 50,
    Board.FIVE: 35,
    Board.SIX: 28,
  };
  Board? board;

  void initState() {
    super.initState();
    board = Board.values.first.board(widget.boardSize);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UpdatePuzzlesProvider>(context);
    x = widget.coord.x;
    y = widget.coord.y;

    return AnimatedPositioned(
      top: y,
      left: x,
      duration: widget.isShuffled ? Duration(milliseconds: 1000) : Duration(milliseconds: 100),
      curve: widget.isShuffled ? Curves.easeInOut : Curves.easeOut,
      child: GestureDetector(
        onTap: () {
          widget.startTimer();
          bool result = widget.func(widget.puzzleNumber);
          if (result) {
            widget.updateTaps();
          }
        },
        child: Container(
          width: widget.puzzleSize,
          height: widget.puzzleSize,
          margin: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage("assets/textures/wood_05.jpg"),
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Colors.brown,
                BlendMode.saturation,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(2, 2),
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(2.5, 2.5),
              ),
              BoxShadow(
                color: Colors.black,
                blurRadius: 1,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Center(
            child: CustomText(
              title: '${widget.puzzleNumber}',
              color: ColorConsts.textColor,
              fontSize: fontSizes[board]!,
              fontFamily: 'Candal',
              fontWeight: FontWeight.w800,
              shadowOffset1: -1,
              blurRadius: 1,
            ),
          ),
        ),
      ),
    );
  }
}
