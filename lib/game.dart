import 'package:flutter_wordle/domain.dart';
import 'package:flutter_wordle/services/keyboard_service.dart';
import 'package:flutter_wordle/services/matching_service.dart';
import 'package:flutter_wordle/services/word_service.dart';

class Wordle {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  late Context _context;

  int _currentIndex = 0;
  final _wordService = WordService();

  void _updateBoard(List<Letter> attempt) {
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

  Wordle init() {
    _context = Context(List.filled(boardSize, Letter(0, ' ', GameColor.unset), growable: false),
        KeyboardService.init().keys, '', '', totalTries, 'Good Luck!');
    Future.delayed(Duration.zero, () async {
      await _wordService.init();
      _context.answer = _wordService.randomWord();
    });
    return this;
  }

  bool _didWin(List<Letter> attempt) => attempt.every((l) => l.color == GameColor.exact);

  String _winningMessage(int remainingTries) {
    switch (remainingTries) {
      case 5:
        return 'Amazing!';
      case 4:
        return 'Fantasic!';
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

  TurnResult takeTurn(String letter) {
    if (KeyboardService.isEnter(letter)) {
      if (!_wordService.isLongEnough(_context.guess)) {
        _context.message = 'Not enough letters';
        return TurnResult.unsuccessful;
      } else if (_wordService.isValidGuess(_context.guess)) {
        var attempt =
            MatchingService.matches(_context.guess.toLowerCase(), _context.answer).toList();
        _updateBoard(attempt);
        _context.keys = _updateKeys(_context.keys, attempt);
        var won = _didWin(attempt);
        var remaining = _context.remainingTries - 1;
        _context.guess = '';
        _context.remainingTries = won ? 0 : remaining;
        _context.message = won
            ? _winningMessage(remaining)
            : remaining == 0
                ? 'Sorry, you lost'
                : '';
        return TurnResult.successful;
      } else {
        _context.message = 'Not in Word list';
        return TurnResult.unsuccessful;
      }
    } else if (KeyboardService.isBackspace(letter)) {
      if (_context.guess.isNotEmpty) {
        var guess = _context.guess.substring(0, _context.guess.length - 1).padRight(rowLength);
        var buffer = guess.split('').map((l) => Letter(0, l, GameColor.unset));
        _updateBoard(buffer.toList());
        _context.guess = guess.replaceAll(' ', '');
        _currentIndex -= 1;
      }
    } else {
      if (_context.guess.length < rowLength) {
        _context.guess = _context.guess + letter;
        _context.board[_currentIndex++] = Letter(0, letter, GameColor.unset);
      }
    }
    return TurnResult.partial;
  }

  Context get context => _context;
}
