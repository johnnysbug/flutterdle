import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_wordle/domain.dart';
import 'package:flutter_wordle/game.dart';
import 'package:flutter_wordle/widgets/board.dart';
import 'package:flutter_wordle/widgets/keyboard.dart';

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
  final _keys = List.filled(Wordle.totalTries, GlobalKey<AnimatorWidgetState>(), growable: false);

  void _onKeyPressed(String val) {
    setState(() {
      var result = _game.takeTurn(val);
      if (result == TurnResult.unsuccessful) {
        var index = (_game.context.remainingTries - Wordle.totalTries).abs();
        _keys[index].currentState?.forward();
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
      }));
    }
  }

  @override
  void initState() {
    _game.init();

    super.initState();
    Future.delayed(Duration.zero, () async {
      await _game.newAnswer();
    });

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
                onTap: () {},
                child: const Icon(
                  Icons.leaderboard,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.settings),
              )),
        ],
      ),
      backgroundColor: Colors.black,
      body: SizedBox.expand(
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
                  Positioned(top: 470, left: 0, child: Keyboard(_game.context.keys, _onKeyPressed)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
