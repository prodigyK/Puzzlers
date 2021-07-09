

import 'package:puzzlers/models/device.dart';

class ScreenUtil {
  static const Map<Device, Map<String, double>> devicesHeight = const {
    Device.ProMax: {
      'width': 260,
      'height': 896,
      'coef': 0.41,
      'stat': 0.39,
      'button': 45,
    },
    Device.Pro: {
      'width': 250,
      'height': 844,
      'coef': 0.43,
      'stat': 0.42,
      'button': 42,
    },
    Device.Mini: {
      'width': 240,
      'height': 812,
      'coef': 0.43,
      'stat': 0.42,
      'button': 40,
    },
    Device.Plus8: {
      'width': 250,
      'height': 736,
      'coef': 0.50,
      'stat': 0.49,
      'button': 45,
    },
    Device.SE2nd: {
      'width': 240,
      'height': 667,
      'coef': 0.52,
      'stat': 0.52,
      'button': 40,
    },
  };


  static Device checkDevice(double height) {
    if (height >= devicesHeight[Device.ProMax]!['height']!) {
      return Device.ProMax;
    } else if (height >= devicesHeight[Device.Pro]!['height']!) {
      return Device.Pro;
    } else if (height >= devicesHeight[Device.Mini]!['height']!) {
      return Device.Mini;
    } else if (height >= devicesHeight[Device.Plus8]!['height']!) {
      return Device.Plus8;
    } else if (height >= devicesHeight[Device.SE2nd]!['height']!) {
      return Device.SE2nd;
    } else {
      return Device.SE2nd;
    }
  }

}