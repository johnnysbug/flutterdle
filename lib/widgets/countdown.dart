import 'dart:async';

import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  final Function newGame;

  const CountdownWidget(this.newGame, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountdownState();
}

class _CountdownState extends State<CountdownWidget> {
  Timer? _countdownTimer;
  Duration? _durationUntilTomorrow;

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
    return Semantics(
      label: 'Next game available in $hours hours, $minutes minutes, and $seconds seconds',
      child: ExcludeSemantics(
        excluding: true,
        child: Text(
          '$hours:$minutes:$seconds',
          style: const TextStyle(
            fontSize: 34,
          ),
        ),
      ),
    );
  }
}
