import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundUtil {
  Soundpool? sound;
  int? soundId;

  void init() {
    sound = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.notification));
    _loadSound().then((value) => soundId = value);
  }

  Future<int?> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/arm_09.wav");
    return await sound?.load(asset);
  }

  void playSound() async {
      await sound?.play(soundId!);
  }

  void release() {
    sound?.release();
  }
}
