import 'dart:convert';
import 'dart:io';

import 'package:flutterdle/domain.dart';
import 'package:path_provider/path_provider.dart';

class SettingsService {
  Future<Settings> load() async {
    final directory = await getApplicationDocumentsDirectory();
    final exists = await File("${directory.path}/settings.json").exists();
    final jsonString = exists ? await File("${directory.path}/settings.json").readAsString() : '';

    if (jsonString.isEmpty) {
      return Settings(true, false, false, KeyboardLayout.qwerty);
    }
    final map = json.decode(jsonString);
    return Settings.fromJson(map);
  }

  Future<void> save(Settings settings) async {
    final directory = await getApplicationDocumentsDirectory();
    await File("${directory.path}/settings.json").writeAsString(json.encode(settings.toJson()));
  }
}
