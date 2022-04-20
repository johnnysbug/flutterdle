import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdle/domain.dart';
import 'package:path_provider/path_provider.dart';

class StatsService {
  Future<String> _readAsset(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await rootBundle.loadString(fileName);
  }

  Future<Stats> loadStats() async {
    final directory = await getApplicationDocumentsDirectory();
    final exists = await File("${directory.path}/stats.json").exists();
    final jsonString = exists
        ? await File("${directory.path}/stats.json").readAsString()
        : await _readAsset('assets/stats.json');

    final map = json.decode(jsonString);
    return Stats.fromJson(map);
  }

  Future<Stats> updateStats(
      Stats stats, bool won, int index, String Function(int n) getSharable, int gameNumber) async {
    if (won) {
      stats.guessDistribution[index] += 1;
      stats.lastGuess = index + 1;
      stats.won += 1;
      stats.streak.current += 1;
      if (stats.streak.current > stats.streak.max) {
        stats.streak.max = stats.streak.current;
      }
    } else {
      stats.lost += 1;
      stats.streak.current = 0;
      stats.lastGuess = -1;
    }
    stats.lastBoard = getSharable(index);
    stats.gameNumber = gameNumber;

    await saveStats(stats);
    return stats;
  }

  Future<void> saveStats(Stats stats) async {
    final directory = await getApplicationDocumentsDirectory();
    await File("${directory.path}/stats.json").writeAsString(json.encode(stats.toJson()));
  }
}
