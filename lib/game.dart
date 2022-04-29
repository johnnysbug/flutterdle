import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/services/context_service.dart';
import 'package:flutterdle/services/keyboard_service.dart';
import 'package:flutterdle/services/matching_service.dart';
import 'package:flutterdle/services/settings_service.dart';
import 'package:flutterdle/services/stats_service.dart';
import 'package:flutterdle/services/version_service.dart';
import 'package:flutterdle/services/word_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Flutterdle {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  static final StatsService _statsService = StatsService();

  final _baseDate = DateTime(2021, DateTime.june, 19);

  late Context _context;
  late Stats _stats;
  late Settings _settings;
  late PackageInfo _packageInfo;
  late final List<GlobalKey<AnimatorWidgetState>> _shakeKeys = [];
  late final List<GlobalKey<AnimatorWidgetState>> _bounceKeys = [];

  final _wordService = WordService();

  bool isEvaluating = false;

  Stats get stats => _stats;
  Settings get settings => _settings;
  PackageInfo get packageInfo => _packageInfo;
  int get gameNumber => DateTime.now().difference(_baseDate).inDays;

  void updateBoard(List<Letter> attempt) {
    for (var i = 0; i < attempt.length; i++) {
      var offset = i + ((totalTries - _context.remainingTries) * rowLength);
      _context.board.tiles[offset] = attempt[i];
    }
  }

  List<List<Letter>> _updateKeys(List<List<Letter>> keys, List<Letter> guess) {
    for (var i = 0; i < guess.length; i++) {
      for (var x = 0; x < keys.length; x++) {
        for (var y = 0; y < keys[x].length; y++) {
          if (keys[x][y].value == guess[i].value && keys[x][y].color.index < guess[i].color.index) {
            keys[x][y] = Letter(value: guess[i].value, color: guess[i].color, isKey: true);
          }
        }
      }
    }
    return keys;
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) {
      return false;
    }
    var today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }

  Future<bool> init() async {
    for (var i = 0; i < totalTries; i++) {
      _shakeKeys.add(GlobalKey<AnimatorWidgetState>());
    }
    for (var i = 0; i < boardSize; i++) {
      _bounceKeys.add(GlobalKey<AnimatorWidgetState>());
    }

    var context = await ContextService().loadContext();
    _stats = await _statsService.loadStats();
    _settings = await SettingsService().load();
    _packageInfo = await VersionService().loadVersion();

    await _wordService.init();
    if (context == null) {
      _initContext();
    } else {
      if (_isToday(context.lastPlayed)) {
        _context = context;
      } else {
        _initContext();
      }
    }
    return true;
  }

  void _initContext() {
    var board = Board(List.filled(boardSize, Letter(), growable: false));
    _context = Context(board, KeyboardService.init(keyboardLayout: _settings.keyboardLayout).keys,
        '', '', [], TurnResult.unset, totalTries, 'Good Luck!', 0, DateTime.now());
    SemanticsService.announce(_context.message, TextDirection.ltr);
    _context.answer = _wordService.getWordOfTheDay(_baseDate);
  }

  bool didWin(List<Letter> attempt) =>
      attempt.isNotEmpty && attempt.every((l) => l.color == GameColor.correct);

  String _winningMessage(int remainingTries) {
    switch (remainingTries) {
      case 5:
        return 'Amazing!';
      case 4:
        return 'Fantastic!';
      case 3:
        return 'Great!';
      case 2:
        return 'Not bad';
      case 1:
        return 'Cutting it close!';
      default:
        return 'Phew!';
    }
  }

  String _getTileBlock(GameColor color) {
    switch (color) {
      case GameColor.tbd:
      case GameColor.absent:
        return '⬛️';
      case GameColor.present:
        return _settings.isHighContrast ? '🟧' : '🟨';
      case GameColor.correct:
        return _settings.isHighContrast ? '🟦' : '🟩';
    }
  }

  String _getShareableBoard(int index) {
    String board = '';
    int endingIndex = ((totalTries - _context.remainingTries) * rowLength) + rowLength;
    for (int i = 0; i < endingIndex; i++) {
      if (i > 0 && i % rowLength == 0) {
        board += '\n';
      }
      board += _getTileBlock(_context.board.tiles[i].color);
    }
    return board;
  }

  Future<Stats> _updateStats(bool won, int remainingTries) async {
    return await _statsService.updateStats(
        _stats, won, (remainingTries - totalTries).abs(), _getShareableBoard, gameNumber);
  }

  void evaluateTurn(String letter) {
    isEvaluating = true;
    _context.turnResult = TurnResult.partial;
    if (KeyboardService.isEnter(letter)) {
      if (!_wordService.isLongEnough(_context.guess)) {
        _context.message = 'Not enough letters';
        SemanticsService.announce(_context.message, TextDirection.ltr);
        _context.turnResult = TurnResult.unsuccessful;
      } else if (_wordService.isValidGuess(_context.guess)) {
        _context.attempt =
            MatchingService.matches(_context.guess.toLowerCase(), _context.answer).toList();
        if (_settings.isHardMode) {
          var unusedLetter = _checkHardMode();
          if (unusedLetter.isNotEmpty) {
            _context.message = 'Guess must contain $unusedLetter';
            SemanticsService.announce(_context.message, TextDirection.ltr);
            _context.turnResult = TurnResult.unsuccessful;
          } else {
            SemanticsService.announce(
                'Your guess ${_context.guess} was accepted', TextDirection.ltr);
            _context.turnResult = TurnResult.successful;
          }
        } else {
          SemanticsService.announce('Your guess ${_context.guess} was accepted', TextDirection.ltr);
          _context.turnResult = TurnResult.successful;
        }
      } else {
        _context.message = 'Not in Word list';
        SemanticsService.announce('${_context.guess} was ${_context.message}', TextDirection.ltr);
        _context.turnResult = TurnResult.unsuccessful;
      }
    } else if (KeyboardService.isBackspace(letter)) {
      if (_context.guess.isNotEmpty) {
        var letterToRemove = _context.guess.characters.last;
        var guess = _context.guess.substring(0, _context.guess.length - 1).padRight(rowLength);
        var buffer = guess.split('').map((l) => Letter(value: l));
        updateBoard(buffer.toList());
        _context.guess = guess.replaceAll(' ', '');
        _context.currentIndex -= 1;
        SemanticsService.announce('$letterToRemove removed', TextDirection.ltr);
      }
    } else {
      if (_context.guess.length < rowLength) {
        _context.guess = _context.guess + letter;
        _context.board.tiles[_context.currentIndex++] = Letter(value: letter);
        SemanticsService.announce('$letter added to board', TextDirection.ltr);
      }
    }
  }

  Context get context => _context;
  List<GlobalKey<AnimatorWidgetState>> get shakeKeys => _shakeKeys;
  List<GlobalKey<AnimatorWidgetState>> get bounceKeys => _bounceKeys;

  Future updateAfterSuccessfulGuess() async {
    if (_context.turnResult == TurnResult.successful) {
      _context.keys = _updateKeys(_context.keys, _context.attempt);
      var won = didWin(_context.attempt);
      if (won || _context.remainingTries == 1) {
        _stats = await _updateStats(won, _context.remainingTries);
      }
      var remaining = _context.remainingTries - 1;
      _context.guess = '';
      _context.attempt = [];
      _context.remainingTries = won ? 0 : remaining;
      _context.message = won
          ? _winningMessage(remaining)
          : remaining == 0
              ? _context.answer
              : '';
      if (_context.message.isNotEmpty) {
        SemanticsService.announce(_context.message, TextDirection.ltr);
      }
      persist();
    }
  }

  void persist() {
    Future.delayed(Duration.zero, () async {
      await ContextService().saveContext(_context);
    });
  }

  String _checkHardMode() {
    var previousMatches = _context.board.tiles
        .where((l) => l.color == GameColor.correct || l.color == GameColor.present)
        .map((l) => l.value);
    var currentMatches = _context.attempt
        .where((l) => l.color == GameColor.correct || l.color == GameColor.present)
        .map((l) => l.value);

    if (previousMatches.isNotEmpty) {
      for (var i = 0; i < previousMatches.length; i++) {
        if (!currentMatches.contains(previousMatches.elementAt(i))) {
          return previousMatches.elementAt(i);
        }
      }
    }
    return '';
  }

  void updateKeyboardLayout() {
    var keys = KeyboardService.init(keyboardLayout: _settings.keyboardLayout).keys;
    for (var row in _context.keys) {
      for (var key in row) {
        keyLoop:
        for (var x = 0; x < keys.length; x++) {
          for (var y = 0; y < keys[x].length; y++) {
            if (keys[x][y].value == key.value) {
              keys[x][y].color = key.color;
              break keyLoop;
            }
          }
        }
      }
    }
    context.keys = keys;
  }
}
