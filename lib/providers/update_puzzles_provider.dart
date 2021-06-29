import 'package:flutter/cupertino.dart';

class UpdatePuzzlesProvider with ChangeNotifier {

  void update() {
    notifyListeners();
  }
}