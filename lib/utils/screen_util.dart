

import 'package:puzzlers/models/device.dart';

class ScreenUtil {
  static const Map<Device, Map<String, double>> devicesHeight = const {
    Device.ProMax: {
      'height': 896,
      'coef': 0.41,
      'stat': 0.39,
    },
    Device.Pro: {
      'height': 844,
      'coef': 0.44,
      'stat': 0.42,
    },
    Device.Mini: {
      'height': 812,
      'coef': 0.44,
      'stat': 0.44,
    },
    Device.Plus8: {
      'height': 736,
      'coef': 0.47,
      'stat': 0.49,
    },
    Device.SE2nd: {
      'height': 667,
      'coef': 0.51,
      'stat': 0.54,
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