import 'dart:convert';
import 'dart:io';

import 'package:flutterdle/domain.dart';
import 'package:path_provider/path_provider.dart';

class ContextService {
  Future<Context?> loadContext() async {
    final directory = await getApplicationDocumentsDirectory();
    final exists = await File("${directory.path}/context.json").exists();
    final String? jsonString;
    if (exists) {
      jsonString = await File("${directory.path}/context.json").readAsString();
      return Context.fromJson(json.decode(jsonString));
    } else {
      return null;
    }
  }

  Future<void> saveContext(Context context) async {
    final directory = await getApplicationDocumentsDirectory();
    await File("${directory.path}/context.json").writeAsString(json.encode(context.toJson()));
  }
}