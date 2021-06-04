import 'package:flutter/material.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/widgets/puzzle.dart';
import 'package:puzzlers/widgets/puzzle_empty.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int rows = 4;
  int cols = 4;
  List<List<int>> matrixBones = [[]];
  List<List<Coord>> matrixCoords = [[]];
  List<Coord> lineCoords = [];
  List<int> bones = [];
  bool firstInit = false;

  @override
  void initState() {
    super.initState();

    bones = List.generate(rows * cols, (index) => ++index);
    lineCoords = List.generate(rows * cols, (index) => Coord(0, 0));
    bones[bones.length - 1] = 0;
    matrixBones = List.generate(rows, (i) => List.filled(cols, 0), growable: false);
    matrixCoords = List.generate(rows, (i) => List.filled(cols, Coord(0, 0)), growable: false);
    _fillMatrixBones();
  }

  void _shufflePuzzles() {
    bones.shuffle();
    for (int i = 0; i < bones.length - 1; i++) {
      if (bones[i] == 0) {
        bones[i] = bones[i + 1];
        bones[i + 1] = 0;
      }
    }
    print(bones);
  }

  Future<void> _fillMatrixBones() async {
    _shufflePuzzles();
    int index = 0;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        matrixBones[i][j] = bones[index];
        index++;
      }
    }
    print(matrixBones);
    print(matrixCoords);
  }

  void _initCoords(double boardSizeInner, double puzzleSize, double indent, double distance) {
    double positionX = indent;
    double positionY = indent;

    int index = 0;
    for (int i = 0; i < rows; i++) {
      positionX = indent;
      for (int j = 0; j < cols; j++) {
        matrixCoords[i][j] = Coord(positionX, positionY);
        lineCoords[index] = matrixCoords[i][j];
        index++;
        positionX += puzzleSize;
        positionX += distance;
      }
      positionY += puzzleSize;
      positionY += distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var boardSizeOuter = size.width * 0.95;
    var boardSizeInner = boardSizeOuter - 20;
    var puzzleSize = boardSizeInner / 4 - 6;

    if (!firstInit) {
      double leftIndent = 3;
      double distanceBetweenPuzzles = 4;
      _initCoords(boardSizeInner, puzzleSize, leftIndent, distanceBetweenPuzzles);
      firstInit = true;
      print(matrixCoords);
    }

    return Scaffold(
      backgroundColor: ColorConsts.bgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Stack(
            children: [
              Container(
                width: boardSizeOuter,
                height: boardSizeOuter,
                decoration: BoxDecoration(
                  color: ColorConsts.boardBorderColor,
                  border: Border.all(color: ColorConsts.boardBorderColor),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: boardSizeInner,
                  height: boardSizeInner,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: ColorConsts.boardBgColor,
                    border: Border.all(color: ColorConsts.boardBorderColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade900,
                        blurRadius: 2,
                        offset: Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: List.generate(rows * cols, (index) {
                      return bones[index] != 0
                          ? Puzzle(coord: lineCoords[index], puzzleSize: puzzleSize, puzzleNumber: bones[index])
                          : PuzzleEmpty(puzzleSize: puzzleSize);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
