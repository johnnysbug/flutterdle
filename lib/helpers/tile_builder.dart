import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';

class TileBuilder {
  
  static Color _toColor(GameColor color, Settings settings) {
    switch (color) {
      case GameColor.correct:
        return settings.isHighContrast ? Colors.orange : Colors.green;
      case GameColor.present:
        return settings.isHighContrast ? Colors.blue : const Color.fromARGB(255, 207, 187, 98);
      case GameColor.absent:
        return const Color.fromARGB(255, 90, 87, 87);
      case GameColor.tbd:
        return Colors.transparent;
    }
  }

  static Widget build(Letter letter, Settings settings) {
    return Padding(
      key: ValueKey(letter.color == GameColor.tbd),
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
              color: _toColor(letter.color, settings)),
          child: FittedBox(
              fit: BoxFit.contain,
              child: Semantics(
                label: letter.semanticsLabel,
                child: ExcludeSemantics(
                  excluding: true,
                  child: Text(
                    letter.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (letter.color != GameColor.tbd) ? Colors.white : null,
                      fontWeight: FontWeight.bold
                      ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}