enum Board {
  THREE,
  FOUR,
  FIVE,
  SIX,
}

extension BoardExtension on Board {
  int get value {
    switch (this) {
      case Board.THREE:
        return 3;
      case Board.FOUR:
        return 4;
      case Board.FIVE:
        return 5;
      case Board.SIX:
        return 6;
    }
  }

  Board board(int boardSize) {
    switch (boardSize) {
      case 3:
        return Board.THREE;
      case 4:
        return Board.FOUR;
      case 5:
        return Board.FIVE;
      case 6:
        return Board.SIX;
      default:
        return Board.FOUR;
    }
  }
}