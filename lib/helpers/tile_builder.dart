import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';

class TileBuilder {
  
  static Color _toColor(GameColor color, Settings settings) {
    switch (color) {
      case GameColor.exact:
        return settings.isHighContrast ? Colors.orange : Colors.green;
      case GameColor.partial:
        return settings.isHighContrast ? Colors.blue : const Color.fromARGB(255, 207, 187, 98);
      case GameColor.none:
        return const Color.fromARGB(255, 90, 87, 87);
      case GameColor.unset:
        return Colors.transparent;
    }
  }

  static Widget build(Letter letter, Settings settings) {
    return Padding(
      key: ValueKey(letter.color == GameColor.unset),
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
                      color: (letter.color != GameColor.unset) ? Colors.white : null,
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