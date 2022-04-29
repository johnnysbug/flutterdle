import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/domain.dart' as domain;
import 'package:flutterdle/services/stats_service.dart';
import 'package:flutterdle/widgets/countdown.dart';
import 'package:share_plus/share_plus.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget(this._stats, this._settings, this._close, this._newGame, {Key? key})
      : super(key: key);

  final Stats _stats;
  final Settings _settings;
  final void Function(domain.Dialog, {bool show}) _close;
  final Function _newGame;

  Stats get stats => _stats;
  Settings get settings => _settings;

  Function(domain.Dialog, {bool show}) get close => _close;
  Function get newGame => _newGame;

  @override
  State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<StatsWidget> {
  int _getFlex(int number, int total) =>
      total == 0 ? 0 : (number / (number + (total - number)) * 10).ceil();

  Future<Stats> get _stats => Future.microtask(() => StatsService().loadStats());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _stats,
        builder: (BuildContext context, AsyncSnapshot<Stats> snapshot) {
          return Material(
            shadowColor: Colors.black12,
            child: BlockSemantics(
              blocking: true,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                      width: 500,
                      height: 520,
                      child: Stack(children: [
                        Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                              width: 410,
                              height: 520,
                              child: Column(children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    TextButton(
                                        onPressed: () =>
                                            widget.close(domain.Dialog.stats, show: false),
                                        child: Semantics(
                                            label: 'tap to close Stats',
                                            child: const ExcludeSemantics(
                                                excluding: true,
                                                child: Text("X", style: TextStyle(fontSize: 20)))))
                                  ],
                                ),
                                const Center(
                                    child: Text(
                                  "STATISTICS",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Column(
                                          children: [
                                            Semantics(
                                              label: 'Games played is ${widget.stats.played}',
                                              child: ExcludeSemantics(
                                                excluding: true,
                                                child: Text(
                                                  widget.stats.played.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 36,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const ExcludeSemantics(
                                              child: Text(
                                                "Played",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Column(
                                          children: [
                                            Semantics(
                                              label: 'Win percentage is ${widget.stats.percentWon}',
                                              child: ExcludeSemantics(
                                                excluding: true,
                                                child: Text(
                                                  widget.stats.percentWon.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 36,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const ExcludeSemantics(
                                              child: Text(
                                                "Win %",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Column(
                                          children: [
                                            Semantics(
                                              label:
                                                  'Current streak is ${widget.stats.streak.current}',
                                              child: ExcludeSemantics(
                                                excluding: true,
                                                child: Text(
                                                  widget.stats.streak.current.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 36,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ExcludeSemantics(
                                              child: Column(children: const [
                                                Center(
                                                    child: Text(
                                                  "Current",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )),
                                                Center(
                                                    child: Text(
                                                  "Streak",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ))
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Column(
                                          children: [
                                            Semantics(
                                              label: 'Max Streak is ${widget.stats.streak.max}',
                                              child: ExcludeSemantics(
                                                excluding: true,
                                                child: Text(
                                                  widget.stats.streak.max.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 36,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ExcludeSemantics(
                                              child: Column(children: const [
                                                Center(
                                                    child: Text(
                                                  "Max",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )),
                                                Center(
                                                    child: Text(
                                                  "Streak",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ))
                                              ]),
                                            ),
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
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              const Center(
                                                  child: Text(
                                                "NEXT FLUTTERDLE",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )),
                                              CountdownWidget(widget.newGame),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          color: Theme.of(context).colorScheme.secondary,
                                          width: 2,
                                          indent: 2,
                                          endIndent: 2,
                                          thickness: 2,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 16, left: 16),
                                            child: Semantics(
                                              label: 'Share button',
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: widget.settings.isHighContrast
                                                        ? Colors.orange
                                                        : Colors.green),
                                                onPressed: () {
                                                  var guesses = widget.stats.lastGuess == -1
                                                      ? 'X'
                                                      : widget.stats.lastGuess;
                                                  Share.share(
                                                      'Flutterdle ${widget.stats.gameNumber} $guesses/6\n${widget.stats.lastBoard}',
                                                      subject: 'Flutterdle $guesses/6');
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
                                                      color: Colors.white,
                                                      size: 24.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ))
                      ]))),
            ),
          );
        });
  }

  Widget _guessDistribution() {
    if (widget.stats.played == 0) {
      return const Center(
          child: Text(
        "No Data",
        style: TextStyle(fontSize: 20),
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

  Widget _statRow(int rowNumber, int completed, int total, {bool isCurrent = false}) {
    return Semantics(
      label:
          'Guess $rowNumber has ${isCurrent ? 'most recently ' : ''}won $completed time${completed == 1 ? '' : 's'}',
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: ExcludeSemantics(
                excluding: true,
                child: Text(
                  rowNumber.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: _getFlex(completed, total),
              child: Container(
                  color: isCurrent
                      ? widget.settings.isHighContrast
                          ? Colors.orange
                          : Colors.green
                      : const Color.fromARGB(255, 90, 87, 87),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: ExcludeSemantics(
                      excluding: true,
                      child: Text(
                        completed.toString(),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
      ),
    );
  }
}
