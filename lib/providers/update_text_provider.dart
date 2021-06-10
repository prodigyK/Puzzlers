import 'package:flutter/cupertino.dart';

class UpdateTextProvider with ChangeNotifier {

  String time = '0:00';
  String taps = '0';

  void updateTime(String newTime) {
    time = newTime;
    notifyListeners();
  }

  void updateTaps(String newTaps) {
    taps = newTaps;
    notifyListeners();
  }


}
