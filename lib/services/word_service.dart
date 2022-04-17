import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'dart:convert';
import 'dart:core';

class WordService {
  late List<String> _answers;
  late List<String> _guesses;

  Future<List<String>> _readFile(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    final text = await rootBundle.loadString(fileName);
    var ls = const LineSplitter();
    return ls.convert(text);
  }

  List<String> get answers => _answers;
  List<String> get guesses => _guesses;
  Iterable<String> get _combined => _answers.followedBy(_guesses);

  Future<void> init() async {
    _answers = await _readFile('assets/answers.txt');
    _guesses = await _readFile('assets/allowed_guesses.txt');
  }

  String getWordOfTheDay(DateTime baseDate) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final millisecondsDiff = (todayDate.difference(baseDate).inMilliseconds);
    final daysDiff = (millisecondsDiff / 864e5).round();
    final index = daysDiff % _answers.length;
    return answers[index];
  }

  bool isValidGuess(String guess) {
    return _combined.contains(guess.toLowerCase());
  }

  bool isLongEnough(String guess) {
    return guess.length == 5;
  }
}
