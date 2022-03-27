import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_wordle/domain.dart';
import 'package:flutter_wordle/game.dart';
import 'package:flutter_wordle/widgets/board.dart';
import 'package:flutter_wordle/widgets/keyboard.dart';
import 'package:flutter_wordle/widgets/stats.dart' as stat;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wordle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Wordle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _game = Wordle();
  final _keys = [
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
    GlobalKey<AnimatorWidgetState>(),
  ];

  bool _showStats = false;

  void _close() {
    setState(() {
      _showStats = false;
    });
  }

  void _onKeyPressed(String val) {
    if (_game.context.remainingTries == 0) {
      return;
    }
    setState(() {
      _game.evaluateTurn(val);
      if (_game.context.turnResult == TurnResult.unsuccessful) {
        var index = (_game.context.remainingTries - Wordle.totalTries).abs();
        _keys[index].currentState?.forward();
      } else if (_game.context.turnResult == TurnResult.successful) {
        for (var i = 0; i < _game.context.attempt.length; i++) {
          var offset = i + ((Wordle.totalTries - _game.context.remainingTries) * Wordle.rowLength);
          Timer(Duration(milliseconds: (i * 200)), () {
            setState(() {
              _game.context.board[offset] = _game.context.attempt[i];
            });
          });
        }
        Timer(const Duration(seconds: 2), () {
          setState(() {
            _game.updateAfterSuccessfulGuess();
            _resetMessage();
          });
        });
      }
    });
    _resetMessage();
  }

  void _resetMessage() {
    if (_game.context.message.isNotEmpty) {
      var duration = const Duration(seconds: 2);
      Timer(duration, (() {
        setState(() {
          _game.context.message = '';
        });
        if (_game.context.remainingTries == 0) {
          Timer(const Duration(milliseconds: 500), (() {
            setState(() {
              _showStats = true;
            });
          }));
        }
      }));
    }
  }

  void _menuItemSelected(int index) {
    switch (index) {
      case 0:
        setState(() {
          _game.init();
        });
        _resetMessage();
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    _game.init();
    super.initState();
    _resetMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => _openStats(),
                child: const Icon(
                  Icons.leaderboard,
                  size: 26.0,
                ),
              )),
          RotatedBox(
            quarterTurns: 1,
            child: PopupMenuButton<int>(
              onSelected: (item) => _menuItemSelected(item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(value: 0, child: Text('New Game')),
                const PopupMenuItem<int>(value: 1, child: Text('Settings')),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(children: [
        SizedBox.expand(
          child: Container(
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 500,
                height: 670,
                child: Stack(
                  children: [
                    Positioned(
                        top: 25, left: 75, child: Board(_game.context, Wordle.rowLength, _keys)),
                    Positioned(
                        top: 470, left: 0, child: Keyboard(_game.context.keys, _onKeyPressed)),
                    if (_showStats) ...[stat.Stats(_game.context.stats, _close)]
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  _openStats() {
    setState(() {
      _showStats = true;
    });
  }
}
