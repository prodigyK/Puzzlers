import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sprintf/sprintf.dart';

class UpdateTimerProvider with ChangeNotifier {

  Timer? _timer;
  int minutes = 0;
  int seconds = 0;
  String time = '0:00';
  String taps = '0';
  bool isShufflePressed = true;

  void cancel() {
    _timer?.cancel();
    isShufflePressed = true;
  }

  Timer? get timer => _timer;

  void updateTime(String newTime) {
    time = newTime;
    notifyListeners();
  }

  void updateTaps(String newTaps) {
    taps = newTaps;
    notifyListeners();
  }

  void incrementTaps() {
    int newTaps = int.parse(taps);
    newTaps++;
    updateTaps(newTaps.toString());
  }


  void startTimer() {
    if (isShufflePressed) {
      clearTimer();
      _timer = Timer.periodic(Duration(seconds: 1), updateTimer);
      isShufflePressed = false;
    }
  }

  void updateTimer(Timer timer) {
    if (seconds == 59) {
      seconds = 0;
      minutes++;
    } else {
      seconds++;
    }

    updateTime(sprintf('%d:%02d', [minutes, seconds]));
  }

  void clearTimer() {
    cancel();
    minutes = 0;
    seconds = 0;
    taps = '0';
    isShufflePressed = true;

    updateTime('0:00');
    updateTaps('0');
  }

}
