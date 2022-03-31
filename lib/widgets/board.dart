import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_wordle/domain.dart';
import 'package:flutter_wordle/helpers/tile_builder.dart';

class Board extends StatelessWidget {
  final List<GlobalKey<AnimatorWidgetState>> _shakeKeys;
  final List<GlobalKey<AnimatorWidgetState>> _bounceKeys;

  final Context _context;
  final int _rowLength;

  const Board(this._context, this._rowLength, this._shakeKeys, this._bounceKeys, {Key? key}) : super(key: key);

  List<Widget> _buildRows() {
    final rows = <Widget>[];
    var board = _context.board;

    var i = 0;
    for (var x = 0; x < board.length / _rowLength; x++) {
      final cells = <Widget>[];
      for (var y = 0; y < _rowLength; y++) {
        cells.add(Flexible(
          child: Bounce(
            key: _bounceKeys[i],
            child: _buildFlipAnimation(board[i]),
          ),
        ));
        i++;
      }
      rows.add(Shake(
          key: _shakeKeys[x],
          preferences: const AnimationPreferences(
              magnitude: 0.7,
              duration: Duration(milliseconds: 700),
              autoPlay: AnimationPlayStates.None),
          child: Flex(
            children: cells,
            direction: Axis.horizontal,
          )));
    }
    return rows;
  }

  Widget _buildFlipAnimation(Letter letter) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: _transitionBuilder,
      layoutBuilder: (widget, list) =>
          Stack(children: widget != null ? [widget, ...list] : [...list]),
      child: TileBuilder.build(letter.value, letter.color),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= -1.0;
        final value = min(rotateAnim.value, pi / 2);
        return Transform(
          transform: (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 350,
        height: 420,
        child: Stack(alignment: Alignment.center, children: [
          Column(children: _buildRows()),
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
