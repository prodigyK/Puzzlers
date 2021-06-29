import 'package:puzzlers/models/coord.dart';
import 'package:puzzlers/models/position.dart';
import 'package:puzzlers/widgets/puzzle.dart';

class CalcUtil {
  static void shuffleClear({required List<Puzzle> puzzleWidgets}) {
    puzzleWidgets.forEach((puzzleWidget) {
      puzzleWidget.isShuffled = false;
    });
  }

  static void shuffleArray({
    required int boardSize,
    required List<int> puzzleNumbers,
  }) {
    do {
      puzzleNumbers.shuffle();
      for (int i = 0; i < puzzleNumbers.length - 1; i++) {
        if (puzzleNumbers[i] == 0) {
          puzzleNumbers[i] = puzzleNumbers[i + 1];
          puzzleNumbers[i + 1] = 0;
        }
      }
      print(puzzleNumbers);
    } while (!CalcUtil.checkMatrixResolvable(
      boardSize: boardSize,
      puzzleNumbers: puzzleNumbers,
    ));
  }

  static Future<void> initMatrixPuzzles({
    required int boardSize,
    required List<List<int>> matrixPuzzles,
    required List<int> puzzleNumbers,
  }) async {
    int index = 0;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        matrixPuzzles[i][j] = puzzleNumbers[index];
        index++;
      }
    }
  }

  static void initMatrixCoords({
    required int boardSize,
    required List<List<Coord>> matrixCoords,
    required List<Coord> lineCoords,
    required double boardSizeInner,
    required double puzzleSize,
    required double indent,
    required double distance,
  }) {
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

  static bool checkMatrixResolvable({
    required int boardSize,
    required List<int> puzzleNumbers,
  }) {
    int count = 0;
    for (int i = 0; i < boardSize * boardSize; i++) {
      if (puzzleNumbers[i] == 0) continue;

      for (int j = 0; j < i; j++) {
        if (puzzleNumbers[j] > puzzleNumbers[i]) {
          count++;
        }
      }
    }
    count += boardSize + boardSize;
    return (count % 2 == 0);
  }

  static Coord getCoordByNumber({
    required int puzzleNumber,
    required int boardSize,
    required List<List<int>> matrixPuzzles,
    required List<List<Coord>> matrixCoords,
  }) {
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

  static Position getPositionByNumber({
    required int puzzleNumber,
    required int boardSize,
    required List<List<int>> matrixPuzzles,
  }) {
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

  static bool calculateFinalSet({
    required int boardSize,
    required List<List<int>> matrixPuzzles,
  }) {
    int count = 1;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (count != matrixPuzzles[i][j]) {
          return false;
        }
        if (boardSize == 3 && count == 8) {
          return true;
        }
        if (boardSize == 4 && count == 15) {
          return true;
        }
        if (boardSize == 5 && count == 24) {
          return true;
        }
        if (boardSize == 6 && count == 35) {
          return true;
        }
        count++;
      }
    }
    return false;
  }
}
