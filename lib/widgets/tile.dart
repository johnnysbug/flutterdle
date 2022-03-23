import 'package:flutter/material.dart';
import 'package:flutter_wordle/domain.dart';

class Tile extends StatelessWidget {
  const Tile(this.letter, this.color, {Key? key}) : super(key: key);

  final String letter;
  final GameColor color;

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
  @override
  Widget build(BuildContext context) {
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
}
