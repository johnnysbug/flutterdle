enum GameColor {
  unset,
  none,
  partial,
  exact,
}

enum TurnResult { successful, unsuccessful, partial }

class Letter {
  int index;
  String value;
  GameColor color;

  Letter(this.index, this.value, this.color);
}

class Context {
  List<Letter> board;
  List<List<Letter>> keys;
  String answer;
  String guess;
  int remainingTries;
  String message;
  int currentIndex;

  Context(this.board, this.keys, this.answer, this.guess, this.remainingTries, this.message, this.currentIndex);
}
