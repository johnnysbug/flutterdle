import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_wordle/domain.dart';
import 'package:flutter_wordle/services/context_service.dart';
import 'package:flutter_wordle/services/keyboard_service.dart';
import 'package:flutter_wordle/services/matching_service.dart';
import 'package:flutter_wordle/services/stats_service.dart';
import 'package:flutter_wordle/services/word_service.dart';

class Wordle {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  final baseDate = DateTime(2021, DateTime.june, 19);

  late Context _context;
  late final List<GlobalKey<AnimatorWidgetState>> _shakeKeys = [];
  late final List<GlobalKey<AnimatorWidgetState>> _bounceKeys = [];

  final _wordService = WordService();

  int get _gameNumber => DateTime.now().difference(baseDate).inDays;

  void updateBoard(List<Letter> attempt) {
    for (var i = 0; i < attempt.length; i++) {
      var offset = i + ((totalTries - _context.remainingTries) * rowLength);
      _context.board[offset] = attempt[i];
    }
  }

  List<List<Letter>> _updateKeys(List<List<Letter>> keys, List<Letter> guess) {
    for (var i = 0; i < guess.length; i++) {
      for (var x = 0; x < keys.length; x++) {
        for (var y = 0; y < keys[x].length; y++) {
          if (keys[x][y].value == guess[i].value && keys[x][y].color.index < guess[i].color.index) {
            keys[x][y] = guess[i];
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
    var stats = await StatsService().loadStats();

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
    _context.stats = stats;
    return true;
  }

  void _initContext() {
    _context = Context(
        List.filled(boardSize, Letter(0, '', GameColor.unset), growable: false),
        KeyboardService.init().keys,
        '',
        '',
        [],
        TurnResult.unset,
        totalTries,
        'Good Luck!',
        0,
        DateTime.now());
    _context.answer = _wordService.getWordOfTheDay(baseDate);
  }

  bool didWin(List<Letter> attempt) => attempt.every((l) => l.color == GameColor.exact);

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
      case GameColor.unset:
      case GameColor.none:
        return '⬛️';
      case GameColor.partial:
        return '🟨';
      case GameColor.exact:
        return '🟩';
    }
  }

  String _getShareableBoard(int index) {
    String board = '';
    int endingIndex = ((totalTries - _context.remainingTries) * rowLength) + rowLength;
    for (int i = 0; i < endingIndex; i++) {
      if (i > 0 && i % rowLength == 0) {
        board += '\n';
      }
      board += _getTileBlock(_context.board[i].color);
    }
    return board;
  }

  void _updateStats(bool won) {
    if (won) {
      var index = (_context.remainingTries - totalTries).abs();
      _context.stats.guessDistribution[index] += 1;
      _context.stats.lastGuess = index + 1;
      _context.stats.won += 1;
      _context.stats.gameNumber = _gameNumber;
      _context.stats.streak.current += 1;
      if (_context.stats.streak.current > _context.stats.streak.max) {
        _context.stats.streak.max = _context.stats.streak.current;
      }
      _context.stats.lastBoard = _getShareableBoard(index);
    } else {
      _context.stats.streak.current = 0;
    }
    Future.delayed(Duration.zero, () async {
      await StatsService().saveStats(_context.stats);
    });
  }

  void evaluateTurn(String letter) {
    _context.turnResult = TurnResult.partial;
    if (KeyboardService.isEnter(letter)) {
      if (!_wordService.isLongEnough(_context.guess)) {
        _context.message = 'Not enough letters';
        _context.turnResult = TurnResult.unsuccessful;
      } else if (_wordService.isValidGuess(_context.guess)) {
        _context.attempt =
            MatchingService.matches(_context.guess.toLowerCase(), _context.answer).toList();
        _context.turnResult = TurnResult.successful;
      } else {
        _context.message = 'Not in Word list';
        _context.turnResult = TurnResult.unsuccessful;
      }
    } else if (KeyboardService.isBackspace(letter)) {
      if (_context.guess.isNotEmpty) {
        var guess = _context.guess.substring(0, _context.guess.length - 1).padRight(rowLength);
        var buffer = guess.split('').map((l) => Letter(0, l, GameColor.unset));
        updateBoard(buffer.toList());
        _context.guess = guess.replaceAll(' ', '');
        _context.currentIndex -= 1;
      }
    } else {
      if (_context.guess.length < rowLength) {
        _context.guess = _context.guess + letter;
        _context.board[_context.currentIndex++] = Letter(0, letter, GameColor.unset);
      }
    }
  }

  Context get context => _context;
  List<GlobalKey<AnimatorWidgetState>> get shakeKeys => _shakeKeys;
  List<GlobalKey<AnimatorWidgetState>> get bounceKeys => _bounceKeys;

  void updateAfterSuccessfulGuess() {
    _context.keys = _updateKeys(_context.keys, _context.attempt);
    var won = didWin(_context.attempt);
    if (won || _context.remainingTries == 1) {
      _updateStats(won);
    }
    var remaining = _context.remainingTries - 1;
    _context.guess = '';
    _context.attempt = [];
    _context.remainingTries = won ? 0 : remaining;
    _context.message = won
        ? _winningMessage(remaining)
        : remaining == 0
            ? 'Sorry, you lost'
            : '';
    Future.delayed(Duration.zero, () async {
      await ContextService().saveContext(_context);
    });
  }
}
