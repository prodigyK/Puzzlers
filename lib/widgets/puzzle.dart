import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/providers/update_puzzles.dart';
import 'package:google_fonts/google_fonts.dart';

class Puzzle extends StatefulWidget {
  Coord coord;
  final double puzzleSize;
  final int puzzleNumber;
  final Function func;
  bool isShuffled = false;
  final int boardSize;
  final Function updateTaps;
  final Function startTimer;
  final Function soundPlay;

  Puzzle({
    Key? key,
    required this.coord,
    required this.puzzleSize,
    required this.puzzleNumber,
    required this.func,
    required this.boardSize,
    required this.updateTaps,
    required this.startTimer,
    required this.soundPlay,
  }) : super(key: key);

  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {

  double x = -1;
  double y = -1;

  Future<void> updateCoord(Coord newCoord) async {
    setState(() {
      widget.coord = newCoord;
    });
  }

  void updateShuffle([bool value = false]) {
    widget.isShuffled = value;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UpdatePuzzles>(context);
    x = widget.coord.x;
    y = widget.coord.y;
    return AnimatedPositioned(
      top: y,
      left: x,
      duration: widget.isShuffled ? Duration(milliseconds: 1000) : Duration(milliseconds: 150),
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
            child: Text(
              '${widget.puzzleNumber}',
              style: GoogleFonts.candal(
                textStyle: TextStyle(
                  color: ColorConsts.boardBgColor,
                  fontSize: widget.boardSize == 4 ? 55 : widget.boardSize == 5 ? 40 : 65,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(-1, -1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
