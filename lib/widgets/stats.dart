import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/domain.dart';
import 'package:share_plus/share_plus.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget(this._stats, this._close, this._newGame, {Key? key}) : super(key: key);

  final Stats _stats;
  final Function _close;
  final Function _newGame;

  Stats get stats => _stats;
  Function get close => _close;
  Function get newGame => _newGame;

  @override
  State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<StatsWidget> {
  Timer? _countdownTimer;
  Duration? _durationUntilTomorrow;

  int _getFlex(int number, int total) => (number / (number + (total - number)) * 10).ceil();

  @override
  void initState() {
    _resetTimer();
    super.initState();
  }

  void _resetTimer() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final midnight = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    final secondsUntilMidnight = midnight.difference(DateTime.now()).inSeconds;

    _durationUntilTomorrow = Duration(seconds: secondsUntilMidnight);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _setCountDown());
  }

  void _setCountDown() {
    const reduceSecondsBy = 1;

    if (mounted) {
      setState(() {
        final seconds = _durationUntilTomorrow!.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          _countdownTimer!.cancel();
          _resetTimer();
          widget.newGame();
        } else {
          _durationUntilTomorrow = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String padDigits(int n) => n.toString().padLeft(2, '0');
    final hours = padDigits(_durationUntilTomorrow!.inHours.remainder(24));
    final minutes = padDigits(_durationUntilTomorrow!.inMinutes.remainder(60));
    final seconds = padDigits(_durationUntilTomorrow!.inSeconds.remainder(60));

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
              width: 500,
              height: 670,
              child: Stack(children: [
                Positioned(
                    top: 75,
                    left: 45,
                    child: SizedBox(
                      width: 410,
                      height: 500,
                      child: Container(
                        color: const Color.fromARGB(255, 29, 29, 29),
                        child: Column(children: [
                          Row(
                            children: [
                              const Spacer(),
                              TextButton(
                                  onPressed: () => widget.close(),
                                  child: const Text("X",
                                      style: TextStyle(color: Colors.white, fontSize: 20)))
                            ],
                          ),
                          const Center(
                              child: Text(
                            "STATISTICS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.stats.played.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                        ),
                                      ),
                                      const Text(
                                        "Played",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.stats.percentWon.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                        ),
                                      ),
                                      const Text(
                                        "Win %",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.stats.streak.current.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                        ),
                                      ),
                                      const Text(
                                        "Current Streak",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.stats.streak.max.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                        ),
                                      ),
                                      const Text(
                                        "Max Streak",
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              "GUESS DISTRIBUTION",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: _guessDistribution(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Column(
                                      children: [
                                        const Center(
                                            child: Text(
                                          "NEXT WORDLE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        )),
                                        Text(
                                          '$hours:$minutes:$seconds',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16, left: 16),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: Colors.green),
                                      onPressed: () {
                                        Share.share(
                                            'Flutter Wordle ${widget.stats.gameNumber} ${widget.stats.lastGuess}/6\n${widget.stats.lastBoard}',
                                            subject: 'Flutter Wordle ${widget.stats.lastGuess}/6');
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('SHARE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18,
                                              )),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.share,
                                            size: 24.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ))
              ]))),
    );
  }

  Widget _guessDistribution() {
    if (widget.stats.played == 0) {
      return const Center(
          child: Text(
        "No Data",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ));
    }

    var maxGuess = widget.stats.guessDistribution.reduce(max);
    var children = <Widget>[];

    for (var i = 0; i < widget.stats.guessDistribution.length; i++) {
      children.add(_statRow(i + 1, widget.stats.guessDistribution[i], maxGuess,
          isCurrent: (i + 1) == widget.stats.lastGuess));
    }
    return Column(children: children);
  }

  Padding _statRow(int rowNumber, int completed, int total, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Text(
              rowNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: _getFlex(completed, total),
            child: Container(
                color: isCurrent ? Colors.green : const Color.fromARGB(255, 90, 87, 87),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    completed.toString(),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )),
          ),
          Expanded(
            flex: _getFlex(total - completed, total),
            child: Container(),
          ),
        ],
      ),
    );
  }
}
