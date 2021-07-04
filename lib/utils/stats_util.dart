import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:puzzlers/models/board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsUtil {
  static Map<Board, dynamic> _bestScores = {
    Board.THREE: 'bestScore3',
    Board.FOUR: 'bestScore4',
    Board.FIVE: 'bestScore5',
    Board.SIX: 'bestScore6',
  };

  static Map<Board, dynamic> _stats = {
    Board.THREE: 'stats3',
    Board.FOUR: 'stats4',
    Board.FIVE: 'stats5',
    Board.SIX: 'stats6',
  };

  static Future<Map<String, dynamic>> getBestScore(int boardSize) async {
    final prefs = await SharedPreferences.getInstance();
    Board board = Board.values.first.board(boardSize);
    String bestScore = prefs.getString(_bestScores[board]) ?? '';

    var map = {
      'taps': '0',
      'time': '0:00',
    };
    return bestScore.isEmpty ? map : await json.decode(bestScore) as Map<String, dynamic>;
  }

  static void updateBestScore({required Map<String, String> newScore, required int boardSize}) async {
    final prefs = await SharedPreferences.getInstance();
    Board board = Board.values.first.board(boardSize);
    final bestScore = json.encode(newScore);
    await prefs.setString(_bestScores[board], bestScore);
  }

  static Future<Map<String, dynamic>> getStats({required int boardSize}) async {
    final prefs = await SharedPreferences.getInstance();
    Board board = Board.values.first.board(boardSize);
    String stats = prefs.getString(_stats[board]) ?? '';

    return stats.isNotEmpty ? await json.decode(stats) as Map<String, dynamic> : {};
  }

  static Future<void> updateStats({required boardSize, required int currentTaps, required String currentTime}) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> stats = await getStats(boardSize: boardSize);
    int games = stats['games'] ?? 0;
    int minTaps = stats['minTaps'] ?? 0;
    int maxTaps = stats['maxTaps'] ?? 0;
    String minTime = stats['minTime'] ?? '0:00';
    String maxTime = stats['maxTime'] ?? '0:00';

    games++;
    minTaps = (currentTaps < minTaps)
        ? currentTaps
        : (minTaps == 0)
            ? currentTaps
            : minTaps;
    maxTaps = (currentTaps > maxTaps)
        ? currentTaps
        : (maxTaps == 0)
            ? currentTaps
            : maxTaps;
    minTime = (currentTime.compareTo(minTime) == -1)
        ? currentTime
        : (minTime == '0:00')
            ? currentTime
            : minTime;
    maxTime = (currentTime.compareTo(maxTime) == 1)
        ? currentTime
        : (maxTime == '0:00')
            ? currentTime
            : maxTime;

    String result = await json.encode({
      'games': games,
      'minTaps': minTaps,
      'maxTaps': maxTaps,
      'minTime': minTime,
      'maxTime': maxTime,
    });
    Board board = Board.values.first.board(boardSize);
    await prefs.setString(_stats[board], result);
  }

  static Future<void> resetStats({required boardSize}) async {
    final prefs = await SharedPreferences.getInstance();
    String result = await json.encode({
      'games': 0,
      'minTaps': 0,
      'maxTaps': 0,
      'minTime': '0:00',
      'maxTime': '0:00',
    });
    Board board = Board.values.first.board(boardSize);
    await prefs.setString(_stats[board], result);

    updateBestScore(
      newScore:{
        'taps': '0',
        'time': '0:00',
      },
      boardSize: boardSize,
    );
  }
}
