import 'package:flutterdle/domain.dart';

class KeyboardService {
  final List<List<Letter>> _keys;

  List<List<Letter>> get keys => _keys;

  KeyboardService._(this._keys);

  static Letter _toLetter(String letter) {
    return Letter(0, letter, GameColor.unset);
  }

  static KeyboardService init() {
    var keys = <List<Letter>>[
      <String>['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'].map((l) => _toLetter(l)).toList(),
      <String>['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'].map((l) => _toLetter(l)).toList(),
      <String>['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACK'].map((l) => _toLetter(l)).toList()
    ];
    return KeyboardService._(keys);
  }

  static bool isEnter(String letter) => letter == 'ENTER';
  static bool isBackspace(String letter) => letter == 'BACK';
}
