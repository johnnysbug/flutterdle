import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdle/app_theme.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/game.dart';
import 'package:flutterdle/widgets/board.dart';
import 'package:flutterdle/widgets/how_to.dart';
import 'package:flutterdle/widgets/keyboard.dart';
import 'package:flutterdle/widgets/settings.dart';
import 'package:flutterdle/widgets/stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StreamController<ThemeMode> _streamController = StreamController.broadcast();
  ThemeMode _appTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();

    _streamController.stream.listen((themeMode) {
      setState(() {
        _appTheme = themeMode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flurdle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: _appTheme,
      darkTheme: AppTheme.darkTheme,
      home: MyHomePage(_appTheme, _streamController, title: 'Flurdle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.themeMode, this.streamController, {Key? key, required this.title})
      : super(key: key);
  final ThemeMode themeMode;
  final StreamController<ThemeMode> streamController;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Flurdle _game = Flurdle();
  Future<bool> _initialized = Future<bool>.value(false);

  bool _showStats = false;
  bool _showHelp = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();

    widget.streamController.stream.listen((themeMode) {
      if (_game.context.theme != themeMode) {
        _game.context.theme = themeMode;
        _game.persist();
      }
    });

    _initialized = _game.init().then((value) {
      widget.streamController.add(_game.context.theme);
      return value;
    });
  }

  void _closeStats() {
    setState(() {
      _showStats = false;
    });
  }

  void _closeHelp() {
    setState(() {
      _showHelp = false;
    });
  }

  void _closeSettings() {
    setState(() {
      _showSettings = false;
    });
  }

  void _onKeyPressed(String val) {
    if (_game.context.remainingTries == 0) {
      return;
    }
    setState(() {
      _game.evaluateTurn(val);
      if (_game.context.turnResult == TurnResult.unsuccessful) {
        var index = (_game.context.remainingTries - Flurdle.totalTries).abs();
        _game.shakeKeys[index].currentState?.forward();
      } else if (_game.context.turnResult == TurnResult.successful) {
        for (var i = 0; i < _game.context.attempt.length; i++) {
          var offset =
              i + ((Flurdle.totalTries - _game.context.remainingTries) * Flurdle.rowLength);
          Timer(Duration(milliseconds: (i * 200)), () {
            setState(() {
              _game.context.board[offset] = _game.context.attempt[i];
            });
          });
        }
        var didWin = _game.didWin(_game.context.attempt);
        var delay = didWin ? 4 : 2;
        if (didWin) {
          Timer(const Duration(seconds: 2), () {
            for (var i = 0; i < _game.context.attempt.length; i++) {
              var offset =
                  i + ((Flurdle.totalTries - _game.context.remainingTries) * Flurdle.rowLength);
              Timer(Duration(milliseconds: (i * 200)), () {
                setState(() {
                  _game.bounceKeys[offset].currentState?.forward();
                });
              });
            }
          });
        }
        Timer(Duration(seconds: delay), () {
          setState(() {
            _game.updateAfterSuccessfulGuess();
            _resetMessage();
          });
        });
      }
    });
    _resetMessage();
  }

  void _newGame() {
    setState(() {
      _game.init();
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.only(left: 16, right: 20.0),
              child: GestureDetector(
                onTap: () => _openHelp(),
                child: const Icon(
                  Icons.help_outline,
                  size: 26.0,
                ),
              )),
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
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => _openSettings(),
                  child: const Icon(
                    Icons.settings,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: FutureBuilder(
            future: _initialized,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              List<Widget> children = [];
              if (snapshot.hasData) {
                _resetMessage();
                children = [
                  Positioned(
                      top: 25,
                      left: 25,
                      child: Board(
                          _game.context, Flurdle.rowLength, _game.shakeKeys, _game.bounceKeys)),
                  Positioned(top: 470, left: 0, child: Keyboard(_game.context.keys, _onKeyPressed)),
                  if (_showStats) ...[
                    Positioned(
                        top: 50,
                        left: 0,
                        child: StatsWidget(_game.context.stats, _closeStats, _newGame))
                  ],
                  if (_showSettings) ...[
                    Positioned(
                        top: 50,
                        left: 0,
                        child: SettingsWidget(_closeSettings, widget.streamController,
                            widget.themeMode == ThemeMode.dark))
                  ]
                ];
              }
              return Stack(children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 400,
                      height: 670,
                      child: Stack(
                        children: children,
                      ),
                    ),
                  ),
                ),
              ]);
            }),
      ),
      if (_showHelp) ...[HowTo(_closeHelp)]
    ]);
  }

  _openHelp() {
    setState(() {
      _showHelp = true;
    });
  }

  _openStats() {
    setState(() {
      _showStats = true;
    });
  }

  _openSettings() {
    setState(() {
      _showSettings = true;
    });
  }
}
