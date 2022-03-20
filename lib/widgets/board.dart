import 'package:flutter/material.dart';
import 'package:flutter_wordle/domain.dart';

class Board extends StatelessWidget {
  final Context _context;
  final int _rowLength;

  const Board(this._context, this._rowLength, {Key? key}) : super(key: key);

  List<Widget> _buildTiles() {
    final rows = <Flex>[];
    var board = _context.board;

    var i = 0;
    for (var x = 0; x < board.length / _rowLength; x++) {
      final cells = <Widget>[];
      for (var y = 0; y < _rowLength; y++) {
        cells.add(_buildCell(board[i].value, board[i].color));
        i++;
      }
      rows.add(Flex(
        children: cells,
        direction: Axis.horizontal,
      ));
    }
    return rows;
  }

  Color _toColor(GameColor color) {
    switch (color) {
      case GameColor.exact:
        return Colors.green;
      case GameColor.partial:
        return const Color.fromARGB(255, 207, 187, 98);
      case GameColor.none:
        return const Color.fromARGB(255, 90, 87, 87);
      case GameColor.unset:
        return Colors.black;
    }
  }

  Widget _buildCell(String letter, GameColor color) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey.shade800,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: _toColor(color)),
            child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  letter,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 350,
        height: 420,
        child: Stack(alignment: Alignment.center, children: [
          Column(children: _buildTiles()),
          if (_context.message.isNotEmpty) ...[
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _context.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  )),
            )
          ]
        ]));
  }
}
