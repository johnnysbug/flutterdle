import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wordle/domain.dart';
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

  Future<void> saveStats(Stats stats) async {
    final directory = await getApplicationDocumentsDirectory();
    await File("${directory.path}/stats.json").writeAsString(json.encode(stats.toJson()));
  }
}
