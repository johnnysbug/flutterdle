import 'package:flutterdle/domain.dart';

class KeyboardService {
  final List<List<Letter>> _keys;

  List<List<Letter>> get keys => _keys;

  KeyboardService._(this._keys);

  static Letter _toLetter(String letter) {
    return Letter(value: letter, isKey: true);
  }

  static KeyboardService init({ KeyboardLayout keyboardLayout = KeyboardLayout.qwerty }) {
    return KeyboardService._(keyboardLayout == KeyboardLayout.qwerty
    ? <List<Letter>>[
      <String>['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'].map((l) => _toLetter(l)).toList(),
      <String>['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'].map((l) => _toLetter(l)).toList(),
      <String>['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACK'].map((l) => _toLetter(l)).toList()
    ]
    : <List<Letter>>[
      <String>['ENTER', 'P', 'Y', 'F', 'G', 'C', 'R', 'L', 'BACK'].map((l) => _toLetter(l)).toList(),
      <String>['A', 'O', 'E', 'U', 'I', 'D', 'H', 'T', 'N', 'S'].map((l) => _toLetter(l)).toList(),
      <String>['Q', 'J', 'K', 'X', 'B', 'M', 'W', 'V', 'Z'].map((l) => _toLetter(l)).toList()
    ]);
  }

  static bool isEnter(String letter) => letter == 'ENTER';
  static bool isBackspace(String letter) => letter == 'BACK';
}
