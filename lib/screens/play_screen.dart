import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puzzlers/constants/color_consts.dart';
import 'package:puzzlers/constants/icons_consts.dart';
import 'package:puzzlers/models/board.dart';
import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/models/position.dart';
import 'package:puzzlers/providers/update_puzzles_provider.dart';
import 'package:puzzlers/providers/update_timer_provider.dart';
import 'package:puzzlers/utils/calc_util.dart';
import 'package:puzzlers/utils/screen_util.dart';
import 'package:puzzlers/utils/stats_util.dart';
import 'package:puzzlers/widgets/congratulation.dart';
import 'package:puzzlers/widgets/custom_decorated_button.dart';
import 'package:puzzlers/widgets/custom_navigation_button.dart';
import 'package:puzzlers/widgets/custom_text.dart';
import 'package:puzzlers/widgets/puzzle.dart';
import 'package:puzzlers/widgets/statistics.dart';
import 'package:sprintf/sprintf.dart';
import 'package:soundpool/soundpool.dart';

typedef ShuffleBoard = void Function();

class PlayScreen extends StatefulWidget {
  static const routeName = '/play-screen';

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
  bool isShuffleDisabled = false;
  Soundpool? sound;
  int? soundId;
  bool isCongratulate = false;
  Congratulations? congratulationWidget;
  Map<Board, double> puzzleSizeDelta = {
    Board.THREE: 5.3,
    Board.FOUR: 5.0,
    Board.FIVE: 4.8,
    Board.SIX: 4.6,
  };
  final backgroundImage = 'assets/textures/wood_02.jpg';
  bool isStatisticsOpen = false;
  bool isStatisticsAnimatedSwitch = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!firstInit) {
      var settings = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
      boardSize = settings['boardSize'] ?? 4;

      var size = MediaQuery.of(context).size;
      boardSizeOuter = size.width * 0.98;
      boardSizeInner = boardSizeOuter - 30;
      Board board = Board.values.first.board(boardSize);
      double delta = puzzleSizeDelta[board] ?? 5.0;
      puzzleSize = boardSizeInner / boardSize - delta;

      double leftIndent = 1;
      double distanceBetweenPuzzles = 4;

      puzzleNumbers = List.generate(boardSize * boardSize, (index) => ++index);
      lineCoords = List.generate(boardSize * boardSize, (index) => Coord(0, 0));
      puzzleNumbers[puzzleNumbers.length - 1] = 0;
      matrixPuzzles = List.generate(boardSize, (i) => List.filled(boardSize, 0), growable: false);
      matrixCoords = List.generate(boardSize, (i) => List.filled(boardSize, Coord(0, 0)), growable: false);

      CalcUtil.shuffleArray(boardSize: boardSize, puzzleNumbers: puzzleNumbers);
      CalcUtil.initMatrixPuzzles(
        boardSize: boardSize,
        matrixPuzzles: matrixPuzzles,
        puzzleNumbers: puzzleNumbers,
      );
      CalcUtil.initMatrixCoords(
        boardSize: boardSize,
        matrixCoords: matrixCoords,
        lineCoords: lineCoords,
        boardSizeInner: boardSizeInner,
        puzzleSize: puzzleSize,
        indent: leftIndent,
        distance: distanceBetweenPuzzles,
      );
      _generatePuzzleList(puzzleSize);
      firstInit = true;
    }
  }

  @override
  void initState() {
    super.initState();
    sound = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));
    _loadSound().then((value) => soundId = value);
  }

  void _shufflePuzzles() {
    puzzleWidgets.forEach((puzzleWidget) {
      Coord coord = CalcUtil.getCoordByNumber(
        puzzleNumber: puzzleWidget.puzzleNumber,
        boardSize: boardSize,
        matrixPuzzles: matrixPuzzles,
        matrixCoords: matrixCoords,
      );
      puzzleWidget.coord = coord;
      puzzleWidget.isShuffled = true;
    });
    Provider.of<UpdatePuzzlesProvider>(context, listen: false).update();
  }

  void _shuffleAndPrepareBoard() {
    if (isShuffleDisabled) return;
    setState(() {
      isShuffleDisabled = true;
    });
    // Shuffle and init arrays
    CalcUtil.shuffleArray(boardSize: boardSize, puzzleNumbers: puzzleNumbers);
    CalcUtil.initMatrixPuzzles(
      boardSize: boardSize,
      matrixPuzzles: matrixPuzzles,
      puzzleNumbers: puzzleNumbers,
    );
    _shufflePuzzles();
    // Timer: clear and create
    var timerProvider = Provider.of<UpdateTimerProvider>(context, listen: false);
    timerProvider.clearTimer();
    Future.delayed(Duration(milliseconds: 1000), () {
      CalcUtil.shuffleClear(puzzleWidgets: puzzleWidgets);
      setState(() {
        isShuffleDisabled = false;
      });
    });
  }

  void _generatePuzzleList(double puzzleSize) {
    var timerProvider = Provider.of<UpdateTimerProvider>(context, listen: false);
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
          updateTaps: timerProvider.incrementTaps,
          startTimer: timerProvider.startTimer,
        );
      },
    );
  }

  bool _calculatePosition(int puzzleNumber) {
    // Get number position in matrix
    Position numberPos = CalcUtil.getPositionByNumber(
      puzzleNumber: puzzleNumber,
      boardSize: boardSize,
      matrixPuzzles: matrixPuzzles,
    );
    Position zeroPos = CalcUtil.getPositionByNumber(
      puzzleNumber: 0,
      boardSize: boardSize,
      matrixPuzzles: matrixPuzzles,
    );

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
    _playSound();
    Provider.of<UpdatePuzzlesProvider>(context, listen: false).update();
    bool isFinish = CalcUtil.calculateFinalSet(
      boardSize: boardSize,
      matrixPuzzles: matrixPuzzles,
    );
    if (isFinish) {
      _congratulate();
    }

    return true;
  }

  void _congratulate() async {
    await StatsUtil.getStats(boardSize: boardSize).then((stat) async {
      if (stat['games'] == null || stat['games'] == 0) {
        await StatsUtil.resetStats(boardSize: boardSize);
      }
    });
    var timerProvider = Provider.of<UpdateTimerProvider>(context, listen: false);
    timerProvider.cancel();
    var bestScore = await StatsUtil.getBestScore(boardSize);
    String bestTaps = bestScore['taps'] ?? '';
    String bestTime = bestScore['time'] ?? '';
    final int currentTaps = int.parse(timerProvider.taps);
    final String currentTime = sprintf('%d:%02d', [timerProvider.minutes, timerProvider.seconds]);

    bestTaps = bestTaps == '0' ? '' : bestTaps;
    bestTime = bestTime == '0:00' ? '' : bestTime;

    congratulationWidget = Congratulations(
      closeDialog: _closeCongratulationDialog,
      goToMenu: _goToMenu,
      bestScore: {
        'taps': bestTaps,
        'time': bestTime,
      },
      currentScore: {
        'taps': currentTaps.toString(),
        'time': currentTime,
      },
    );
    // Update statistics
    await StatsUtil.updateStats(boardSize: boardSize, currentTaps: currentTaps, currentTime: currentTime);
    StatsUtil.getStats(boardSize: boardSize).then((value) => print(value));
    // Check for tbe best score
    if (bestTime.isEmpty && bestTaps.isEmpty) {
      bestTaps = currentTaps.toString();
      bestTime = currentTime;
      congratulationWidget?.isBetter = true;
    } else if (int.parse(timerProvider.taps) < int.parse(bestTaps)) {
      bestTaps = timerProvider.taps;
      bestTime = currentTime;
      congratulationWidget?.isBetter = true;
    } else if (int.parse(timerProvider.taps) == int.parse(bestTaps)) {
      if (currentTime.compareTo(bestTime) < 0) {
        bestTime = currentTime;
        congratulationWidget?.isBetter = true;
      }
    }

    StatsUtil.updateBestScore(
      newScore: {
        'taps': bestTaps,
        'time': bestTime,
      },
      boardSize: boardSize,
    );
    setState(() {
      isCongratulate = true;
    });
    Future.delayed(Duration(milliseconds: 50), () {
      congratulationWidget?.isVisible = true;
      Provider.of<UpdatePuzzlesProvider>(context, listen: false).update();
    });
  }

  Future<int?> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/arm_09.wav");
    return await sound?.load(asset);
  }

  void _playSound() async {
    if (!isMute) {
      await sound?.play(soundId!);
    }
  }

  void _closeCongratulationDialog() {
    setState(() {
      isCongratulate = false;
    });
    _shuffleAndPrepareBoard();
  }

  void _goToMenu() {
    Provider.of<UpdateTimerProvider>(context, listen: false).clearTimer();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    sound?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
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
        body: Stack(
          children: [
            Container(
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
                          child: CustomNavigationButton(
                            onTap: () {
                              Provider.of<UpdateTimerProvider>(context, listen: false).clearTimer();
                              Navigator.of(context).pop();
                            },
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
                                  CustomText(
                                    title: 'Time',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: 'Candal',
                                    shadowOffset1: 0.3,
                                    shadowOffset2: 0.5,
                                    shadowOffset3: 0.7,
                                  ),
                                  Spacer(),
                                  CustomText(
                                    title: 'Taps',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: 'Candal',
                                    blurRadius: 1.0,
                                    shadowOffset1: 0.3,
                                    shadowOffset2: 0.5,
                                    shadowOffset3: 0.7,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Consumer<UpdateTimerProvider>(
                                    builder: (_, value, child) => CustomText(
                                      title: '${value.timer != null ? value.time : "0:00"}',
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Candal',
                                      blurRadius: 2,
                                      shadowOffset1: 0.3,
                                      shadowOffset2: 0.5,
                                      shadowOffset3: 0.7,
                                    ),
                                  ),
                                  Spacer(),
                                  Consumer<UpdateTimerProvider>(
                                    builder: (_, value, child) => CustomText(
                                      title: value.taps,
                                      //'$taps',
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Candal',
                                      blurRadius: 2,
                                      shadowOffset1: 0.3,
                                      shadowOffset2: 0.5,
                                      shadowOffset3: 0.7,
                                    ),
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
                                borderRadius: BorderRadius.circular(25),
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
                                    color: Colors.grey.shade900,
                                    blurRadius: 1,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                width: boardSizeInner,
                                height: boardSizeInner,
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: ColorConsts.textColor,
                                  border: Border.all(color: ColorConsts.boardBorderColor),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage("assets/textures/wood_02.jpg"),
                                    fit: BoxFit.contain,
                                    repeat: ImageRepeat.repeat,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white60,
                                      BlendMode.softLight,
                                    ),
                                  ),
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
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomDecoratedButton(
                              width: 70,
                              height: 70,
                              icon: IconConsts.info,
                              iconSize: 30,
                              onTap: () {
                                setState(() {
                                  isStatisticsOpen = true;
                                  isStatisticsAnimatedSwitch = true;
                                });
                              },
                            ),
                            CustomDecoratedButton(
                              title: 'Shuffle',
                              width: 100,
                              height: 100,
                              icon: CupertinoIcons.arrow_2_circlepath,
                              iconSize: 50,
                              onTap: _shuffleAndPrepareBoard,
                            ),
                            CustomDecoratedButton(
                              width: 70,
                              height: 70,
                              icon: isMute ? IconConsts.volumeMute : IconConsts.volumeUp,
                              iconSize: 30,
                              onTap: () {
                                setState(() {
                                  isMute = !isMute;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isCongratulate,
              child: Center(child: congratulationWidget),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isStatisticsAnimatedSwitch ? 1.0 : 0.0,
              child: Visibility(
                visible: isStatisticsOpen,
                child: Statistics(
                  boardSize: boardSize,
                  device: ScreenUtil.checkDevice(size.height),
                  closeDialog: () {
                    setState(() {
                      isStatisticsAnimatedSwitch = false;
                    });
                    Future.delayed(Duration(milliseconds: 200), () {
                      setState(() {
                        isStatisticsOpen = false;
                      });
                    });
                  },
                  resetStats: () async {
                    await StatsUtil.resetStats(boardSize: boardSize);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
