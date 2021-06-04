
class Coord {
  double _x;
  double _y;

  Coord(this._x, this._y);

  double get x => _x;
  double get y => _y;

  @override
  String toString() {
    return 'Coord{x: $_x, y: $_y}';
  }
}
