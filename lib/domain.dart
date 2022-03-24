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
  late Stats stats;

  Context(this.board, this.keys, this.answer, this.guess, this.remainingTries, this.message,
      this.currentIndex);
}

class Stats {
  int won;
  int lost;
  Streak streak;
  List<int> guessDistribution;
  int lastGuess;
  String lastBoard;

  Stats(this.won, this.lost, this.streak, this.guessDistribution, this.lastGuess, this.lastBoard);

  Stats.fromJson(Map<String, dynamic> json)
      : won = json['won'],
        lost = json['lost'],
        streak = json['streak'] = Streak.fromJson(json['streak']),
        guessDistribution = json['guessDistribution'].cast<int>(),
        lastGuess = json['lastGuess'],
        lastBoard = json['lastBoard'] ?? '';

  int get played => guessDistribution.reduce((value, g) => value + g);

  int get percentWon => played == 0 ? 0 : (played / won * 100).round();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['won'] = won;
    data['lost'] = lost;
    data['streak'] = streak.toJson();
    data['guessDistribution'] = guessDistribution;
    data['lastGuess'] = lastGuess;
    data['lastBoard'] = lastBoard;
    return data;
  }
}

class Streak {
  int current;
  int max;

  Streak(this.current, this.max);

  Streak.fromJson(Map<String, dynamic> json)
      : current = json['current'],
        max = json['max'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['max'] = max;
    return data;
  }
}
