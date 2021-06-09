import 'dart:async';

import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/models/position.dart';
import 'package:puzzlers/providers/update_puzzles.dart';
import 'package:puzzlers/widgets/puzzle.dart';
import 'package:sprintf/sprintf.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int boardSize = 4;
  List<List<int>> matrixPuzzles = [[]];
  List<List<Coord>> matrixCoords = [[]];
  List<Coord> lineCoords = [];
  List<int> puzzleNumbers = [];
  bool firstInit = false;
  List<Puzzle> puzzleWidgets = [];
  double boardSizeOuter = 0.0;
  double boardSizeInner = 0.0;
  double puzzleSize = 0.0;
  bool isMute = false;
  bool isStarted = false;
  Timer? _timer;
  String _time = '0:00';
  int minutes = 0;
  int seconds = 0;
  int taps = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!firstInit) {
      var size = MediaQuery.of(context).size;
      boardSizeOuter = size.width * 0.95;
      boardSizeInner = boardSizeOuter - 20;
      puzzleSize = boardSizeInner / boardSize - 6;

      double leftIndent = 3;
      double distanceBetweenPuzzles = 4;
      _initMatrixCoords(boardSizeInner, puzzleSize, leftIndent, distanceBetweenPuzzles);
      _generatePuzzleList(puzzleSize);
      firstInit = true;
    }
  }

  @override
  void initState() {
    super.initState();

    puzzleNumbers = List.generate(boardSize * boardSize, (index) => ++index);
    lineCoords = List.generate(boardSize * boardSize, (index) => Coord(0, 0));
    puzzleNumbers[puzzleNumbers.length - 1] = 0;
    matrixPuzzles = List.generate(boardSize, (i) => List.filled(boardSize, 0), growable: false);
    matrixCoords = List.generate(boardSize, (i) => List.filled(boardSize, Coord(0, 0)), growable: false);
    _shuffleArray();
    _initMatrixPuzzles();
  }

  void _shuffleArray() {
    puzzleNumbers.shuffle();
    for (int i = 0; i < puzzleNumbers.length - 1; i++) {
      if (puzzleNumbers[i] == 0) {
        puzzleNumbers[i] = puzzleNumbers[i + 1];
        puzzleNumbers[i + 1] = 0;
      }
    }
    print(puzzleNumbers);
  }

  void _shufflePuzzles() {
    puzzleWidgets.forEach((puzzleWidget) {
      Coord coord = _getCoordByNumber(puzzleWidget.puzzleNumber);
      puzzleWidget.coord = coord;
      puzzleWidget.isShuffled = true;
    });
    Provider.of<UpdatePuzzles>(context, listen: false).update();
  }

  void _shuffleClear() {
    puzzleWidgets.forEach((puzzleWidget) {
      puzzleWidget.isShuffled = false;
    });
  }

  Future<void> _initMatrixPuzzles() async {
    int index = 0;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        matrixPuzzles[i][j] = puzzleNumbers[index];
        index++;
      }
    }
  }

  void _initMatrixCoords(double boardSizeInner, double puzzleSize, double indent, double distance) {
    double positionX = indent;
    double positionY = indent;

    int index = 0;
    for (int i = 0; i < boardSize; i++) {
      positionX = indent;
      for (int j = 0; j < boardSize; j++) {
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

  void _generatePuzzleList(double puzzleSize) {
    puzzleWidgets = List.generate(
      boardSize * boardSize - 1,
      (index) {
        return Puzzle(
          key: ValueKey(puzzleNumbers[index]),
          coord: lineCoords[index],
          puzzleSize: puzzleSize,
          puzzleNumber: puzzleNumbers[index],
          func: _calculatePosition,
          boardSize: boardSize,
          updateTaps: _updateTaps,
        );
      },
    );
  }

  Coord _getCoordByNumber(int puzzleNumber) {
    int posX = -1;
    int posY = -1;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (matrixPuzzles[i][j] == puzzleNumber) {
          posX = j;
          posY = i;
          break;
        }
      }
    }
    if (posX == -1 || posY == -1) {
      return Coord(-1, -1);
    }
    return matrixCoords[posY][posX];
  }

  Position _getPositionByNumber(int puzzleNumber) {
    int posX = -1;
    int posY = -1;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (matrixPuzzles[i][j] == puzzleNumber) {
          posX = j;
          posY = i;
          break;
        }
      }
    }
    if (posX == -1 || posY == -1) {
      return Position(-1, -1);
    }
    return Position(posX, posY);
  }

  bool _calculatePosition(int puzzleNumber) {
    print(puzzleNumber);

    // Get number position in matrix
    Position numberPos = _getPositionByNumber(puzzleNumber);
    Position zeroPos = _getPositionByNumber(0);

    bool isHorizontal = false;
    bool isVertical = false;
    int posX = numberPos.x;
    int posY = numberPos.y;
    int zeroPosX = zeroPos.x;
    int zeroPosY = zeroPos.y;

    if (posX == -1 || posY == -1) {
      return false;
    }

    if (posX == zeroPosX) {
      isVertical = true;
    } else if (posY == zeroPosY) {
      isHorizontal = true;
    } else {
      return false;
    }

    List<Position> positions = [];
    if (isHorizontal) {
      if (posX < zeroPosX) {
        for (int i = zeroPosX - 1; i >= posX; i--) {
          int number = matrixPuzzles[posY][i];
          var puzzle = puzzleWidgets.where((widget) => widget.puzzleNumber == number).first;
          matrixPuzzles[posY][i] = 0;
          matrixPuzzles[posY][i + 1] = number;
          puzzle.coord = matrixCoords[posY][i + 1];
        }
      } else if (posX > zeroPosX) {
        for (int i = zeroPosX + 1; i <= posX; i++) {
          int number = matrixPuzzles[posY][i];
          var puzzle = puzzleWidgets.where((widget) => widget.puzzleNumber == number).first;
          matrixPuzzles[posY][i] = 0;
          matrixPuzzles[posY][i - 1] = number;
          puzzle.coord = matrixCoords[posY][i - 1];
        }
      }
    } else if (isVertical) {
      if (posY < zeroPosY) {
        for (int i = zeroPosY - 1; i >= posY; i--) {
          int number = matrixPuzzles[i][posX];
          var puzzle = puzzleWidgets.where((widget) => widget.puzzleNumber == number).first;
          matrixPuzzles[i][posX] = 0;
          matrixPuzzles[i + 1][posX] = number;
          puzzle.coord = matrixCoords[i + 1][posX];
        }
      } else if (posY > zeroPosY) {
        for (int i = zeroPosY + 1; i <= posY; i++) {
          int number = matrixPuzzles[i][posX];
          var puzzle = puzzleWidgets.where((widget) => widget.puzzleNumber == number).first;
          matrixPuzzles[i][posX] = 0;
          matrixPuzzles[i - 1][posX] = number;
          puzzle.coord = matrixCoords[i - 1][posX];
        }
      }
    }
    Provider.of<UpdatePuzzles>(context, listen: false).update();

    return true;
  }

  void _updateTimer(Timer timer) {
    // int tick = timer.tick % 10;
    if (seconds == 59) {
      seconds = 0;
      minutes++;
    } else {
      seconds++;
    }

    setState(() {
      _time = sprintf('%d:%02d', [minutes, seconds]);
    });
  }

  void _clearTimer() {
    _timer?.cancel();
    _time = '0:00';
    minutes = 0;
    seconds = 0;
    taps = 0;
  }

  void _updateTaps() {
    setState(() {
      ++taps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.bgColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _decoratedIconWidget(
                            icon: FontAwesome5.angle_double_left,
                            iconSize: 46,
                          ),
                          _textWidget(
                            title: 'Back',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _textWidget(
                              title: 'Time',
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              shadowOffset1: 0.5,
                              shadowOffset2: 1.0,
                              shadowOffset3: 1.5,
                            ),
                            Spacer(),
                            _textWidget(
                              title: 'Taps',
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              shadowOffset1: 0.5,
                              shadowOffset2: 1.0,
                              shadowOffset3: 1.5,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _textWidget(
                              title: '${_timer != null ? _time : "0:00"}',
                              fontSize: 50,
                              fontWeight: FontWeight.w400,
                            ),
                            Spacer(),
                            _textWidget(
                              title: '$taps',
                              fontSize: 50,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
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
                              offset: Offset(2, 2),
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
                            children: puzzleWidgets,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Shuffle and init arrays
                            _shuffleArray();
                            _initMatrixPuzzles();
                            _shufflePuzzles();
                            // Timer: clear and create
                            setState(() {
                              _clearTimer();
                            });
                            Future.delayed(Duration(milliseconds: 1300), () {
                              _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
                              _shuffleClear();
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _decoratedIconWidget(
                                icon: FontAwesome5.sync_alt,
                                iconSize: 60,
                              ),
                              _textWidget(
                                title: 'Restart',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 50,
                          top: 20,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isMute = !isMute;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _decoratedIconWidget(
                                  icon: isMute ? FontAwesome5.volume_mute : FontAwesome5.volume_up,
                                  iconSize: 36,
                                ),
                                _textWidget(
                                  title: 'Mute',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DecoratedIcon _decoratedIconWidget({
    required IconData icon,
    double iconSize = 24.0,
    double shadowOffset1 = 1.0,
    double shadowOffset2 = 2.0,
    double shadowOffset3 = 3.0,
    double blurRadius = 5.0,
  }) {
    return DecoratedIcon(
      icon,
      size: iconSize,
      color: ColorConsts.boardBorderColor,
      shadows: [
        BoxShadow(
          blurRadius: blurRadius,
          color: Colors.black,
          offset: Offset(shadowOffset1, shadowOffset1),
        ),
        BoxShadow(
          blurRadius: blurRadius,
          color: Colors.black,
          offset: Offset(shadowOffset2, shadowOffset2),
        ),
        BoxShadow(
          blurRadius: blurRadius,
          color: Colors.black,
          offset: Offset(shadowOffset3, shadowOffset3),
        ),
      ],
    );
  }

  Text _textWidget(
      {String? title,
      double? fontSize,
      FontWeight? fontWeight,
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
            blurRadius: 1,
            offset: Offset(shadowOffset1, shadowOffset1),
          ),
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(shadowOffset2, shadowOffset2),
          ),
          BoxShadow(
            color: Colors.black,
            blurRadius: 1,
            offset: Offset(shadowOffset3, shadowOffset3),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
