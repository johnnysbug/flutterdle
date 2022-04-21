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
  final StreamController<Settings> _streamController = StreamController.broadcast();
  ThemeMode _appTheme = ThemeMode.dark;

  @override
  void initState() {
    super.initState();

    _streamController.stream.listen((settings) {
      setState(() {
        _appTheme = settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterdle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: _appTheme,
      darkTheme: AppTheme.darkTheme,
      home: MyHomePage(_appTheme, _streamController, title: 'Flutterdle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.themeMode, this.streamController, {Key? key, required this.title})
      : super(key: key);
  final ThemeMode themeMode;
  final StreamController<Settings> streamController;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Flutterdle _game = Flutterdle();
  Future<bool> _initialized = Future<bool>.value(false);

  bool _showStats = false;
  bool _showHelp = false;
  bool _showSettings = false;

  @override
  void initState() {
    super.initState();

    widget.streamController.stream.listen((settings) {
      if (_game.settings.isDarkMode != settings.isDarkMode) {
        _game.settings.isDarkMode = settings.isDarkMode;
        _game.persist();
      }
    });

    _initialized = _game.init().then((value) {
      widget.streamController.add(_game.settings);
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
    if (_game.context.remainingTries == 0 || _game.isEvaluating) {
      return;
    }
    setState(() {
      _game.evaluateTurn(val);
      if (_game.context.turnResult == TurnResult.unsuccessful) {
        var index = (_game.context.remainingTries - Flutterdle.totalTries).abs();
        _game.shakeKeys[index].currentState?.forward();
        _game.isEvaluating = false;
      } else if (_game.context.turnResult == TurnResult.successful) {
        for (var i = 0; i < _game.context.attempt.length; i++) {
          var offset =
              i + ((Flutterdle.totalTries - _game.context.remainingTries) * Flutterdle.rowLength);
          Timer(Duration(milliseconds: (i * 200)), () {
            setState(() {
              _game.context.board.tiles[offset] = _game.context.attempt[i];
            });
          });
        }
        var didWin = _game.didWin(_game.context.attempt);
        var delay = didWin ? 4 : 2;
        if (didWin) {
          Timer(const Duration(seconds: 2), () {
            for (var i = 0; i < _game.context.attempt.length; i++) {
              var offset = i +
                  ((Flutterdle.totalTries - _game.context.remainingTries) * Flutterdle.rowLength);
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
            _game.updateAfterSuccessfulGuess().then((_) => setState(() {}));
            _resetMessage();
            _game.isEvaluating = false;
          });
        });
      } else {
        _game.isEvaluating = false;
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
    return FutureBuilder(
        future: _initialized,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> children = [];
          if (snapshot.hasData) {
            _resetMessage();
            children = [
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
                          padding: const EdgeInsets.only(left: 16, right: 16.0),
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
                  body: Stack(children: [
                    SizedBox.expand(
                        child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                                width: 400,
                                height: 670,
                                child: Stack(children: [
                                  Positioned(
                                      top: 25,
                                      left: 25,
                                      child: BoardWidget(_game.context, Flutterdle.rowLength,
                                          _game.shakeKeys, _game.bounceKeys)),
                                  Positioned(
                                      top: 470,
                                      left: 0,
                                      child: Keyboard(_game.context.keys, _onKeyPressed)),
                                  if (_showStats) ...[
                                    Positioned(
                                        top: 50,
                                        left: 0,
                                        child: StatsWidget(_game.stats, _closeStats, _newGame))
                                  ],
                                  if (_showSettings) ...[
                                    Positioned(
                                        top: 50,
                                        left: 0,
                                        child: SettingsWidget(_closeSettings,
                                            widget.streamController, _game.settings))
                                  ]
                                ])))),
                  ])),
              if (_showHelp) ...[SafeArea(child: HowTo(_closeHelp))]
            ];
          } else {
            children = [
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ];
          }
          return Stack(children: children);
        });
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
