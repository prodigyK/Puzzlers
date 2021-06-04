import 'package:flutter/material.dart';

class PuzzleEmpty extends StatelessWidget {
  final double puzzleSize;

  const PuzzleEmpty({
    Key? key,
    required this.puzzleSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: puzzleSize,
      height: puzzleSize,
      margin: EdgeInsets.all(0),
    );
  }
}