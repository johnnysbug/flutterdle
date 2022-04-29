import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/game.dart';
import 'package:flutterdle/helpers/tile_builder.dart';

class BoardWidget extends StatelessWidget {
  final List<GlobalKey<AnimatorWidgetState>> _shakeKeys;
  final List<GlobalKey<AnimatorWidgetState>> _bounceKeys;
  final Settings _settings;

  final Flutterdle _game;
  final int _rowLength;

  const BoardWidget(this._game, this._rowLength, this._shakeKeys, this._bounceKeys, this._settings,
      {Key? key})
      : super(key: key);

  List<Widget> _buildRows() {
    final rows = <Widget>[];
    var tiles = _game.context.board.tiles;

    var i = 0;
    for (var x = 0; x < tiles.length / _rowLength; x++) {
      final cells = <Widget>[];
      for (var y = 0; y < _rowLength; y++) {
        cells.add(Flexible(
          child: Bounce(
            key: _bounceKeys[i],
            preferences: const AnimationPreferences(autoPlay: AnimationPlayStates.None),
            child: _buildFlipAnimation(tiles[i]),
          ),
        ));
        i++;
      }
      var startAt = x * Flutterdle.rowLength;
      var endAt = startAt + (Flutterdle.rowLength - 1);
      rows.add(Shake(
          key: _shakeKeys[x],
          preferences: const AnimationPreferences(
              magnitude: 0.7,
              duration: Duration(milliseconds: 700),
              autoPlay: AnimationPlayStates.None),
          child: Semantics(
            label: tiles.getRange(startAt, endAt).any((t) => t.color == GameColor.tbd)
                ? ''
                : _convertNumber(x + 1),
            child: Flex(
              children: cells,
              direction: Axis.horizontal,
            ),
          )));
    }
    return rows;
  }

  String _convertNumber(int x) {
    switch (x) {
      case 1:
        return 'First guess';
      case 2:
        return 'Second guess';
      case 3:
        return 'Third guess';
      case 4:
        return 'Fourth guess';
      case 5:
        return 'Fifth guess';
      case 6:
        return 'Sixth guess';
      default:
        return 'However you got here, that is just between you and me. The guy who wrote this code. Have a great day.';
    }
  }

  Widget _buildFlipAnimation(Letter letter) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: _transitionBuilder,
      layoutBuilder: (widget, list) =>
          Stack(children: widget != null ? [widget, ...list] : [...list]),
      child: TileBuilder.build(letter, _settings),
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
    return Semantics(
      label: "game number ${_game.gameNumber}",
      child: SizedBox(
          width: 350,
          height: 420,
          child: Stack(alignment: Alignment.center, children: [
            Column(children: _buildRows()),
            if (_game.context.message.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
                child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        _game.context.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    )),
              )
            ]
          ])),
    );
  }
}
