import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

class SoundUtil {
  static Soundpool? _sound;
  static int? _soundId;
  static bool _isMuted = false;
  static const String _IS_MUTED = 'isMuted';

  static bool get isMuted => _isMuted;
  static set isMuted(bool value) => _isMuted = value;

  static Future<void> init() async {
    var result = await loadSettings();
    if(!result) {
      _sound = Soundpool.fromOptions(options: SoundpoolOptions(streamType: StreamType.music));
      _loadSound().then((value) => _soundId = value);
    }
  }

  static Future<bool> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool(_IS_MUTED) ?? false;
    return _isMuted;
  }

  static void saveSettings(bool muted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_IS_MUTED, muted);
    _isMuted = muted;
  }

  static Future<int?> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/arm_09.wav");
    return await _sound?.load(asset);
  }

  static void playSound() async {
    await _sound?.play(_soundId!);
  }

  static void release() {
    _sound?.release();
    _sound = null;
  }
}
