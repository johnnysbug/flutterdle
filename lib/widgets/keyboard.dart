import 'package:flutter/material.dart';
import 'package:flutter_wordle/domain.dart';

class Keyboard extends StatelessWidget {
  final List<List<Letter>> _keys;
  final ValueSetter<String> _onKeyPressed;

  const Keyboard(this._keys, this._onKeyPressed, {Key? key}) : super(key: key);

  Color _toColor(GameColor color) {
    switch (color) {
      case GameColor.exact:
        return Colors.green;
      case GameColor.partial:
        return const Color.fromARGB(255, 207, 187, 98);
      case GameColor.none:
        return const Color.fromARGB(255, 90, 87, 87);
      case GameColor.unset:
        return const Color.fromARGB(255, 151, 151, 151);
    }
  }

  Widget _buildCell(String letter, GameColor color) {
    return SizedBox(
      width: letter.length > 1 ? 60 : 40,
      height: 58,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey.shade800,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: _toColor(color)),
          child: TextButton(
              onPressed: () {
                _onKeyPressed.call(letter);
              },
              child: Text(
                letter,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: letter.length > 1 ? 10 : 18, color: Colors.white),
              )),
        ),
      ),
    );
  }

  List<Row> _buildKeys() {
    final rows = <Row>[];

    for (var x = 0; x < _keys.length; x++) {
      final cells = <Widget>[];
      for (var y = 0; y < _keys[x].length; y++) {
        cells.add(_buildCell(_keys[x][y].value, _keys[x][y].color));
      }
      rows.add(Row(children: cells, mainAxisAlignment: MainAxisAlignment.center));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 400, height: 200, child: Column(children: _buildKeys()));
  }
}
