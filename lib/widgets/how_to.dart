import 'package:flutter/material.dart';
import 'package:flutter_wordle/domain.dart' as stats;
import 'package:flutter_wordle/helpers/tile_builder.dart';

class HowTo extends StatelessWidget {
  const HowTo(this._close, {Key? key}) : super(key: key);

  final Function _close;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
              width: 500,
              height: 840,
              child: Stack(children: [
                Positioned(
                    top: 40,
                    left: 0,
                    child: SizedBox(
                      width: 500,
                      height: 800,
                      child: Container(
                        color: const Color.fromARGB(255, 29, 29, 29),
                        child: Column(children: [
                          Row(
                            children: [
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.only(left: 48),
                                child: Text(
                                  "HOW TO PLAY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () => _close(),
                                  child: const Text("X",
                                      style: TextStyle(color: Colors.white, fontSize: 20)))
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                      text: 'Guess the ',
                                      children: [
                                        TextSpan(
                                            text: 'WORDLE',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' in six tries.')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: RichText(
                                textScaleFactor: 1.25,
                                text: const TextSpan(
                                    text:
                                        'Each guess must be a valid five-letter word. Hit the enter button to submit.')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: RichText(
                                textScaleFactor: 1.25,
                                text: const TextSpan(
                                    text:
                                        'After each guess, the color of the tiles will change to show how close your guess was to the word.')),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(color: Colors.grey.shade800),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                        text: "Examples",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        )),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.centerLeft,
                                width: 300,
                                height: 80,
                                child: Flex(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(child: TileBuilder.build('W', stats.GameColor.exact)),
                                    Flexible(child: TileBuilder.build('E', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('A', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('R', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('Y', stats.GameColor.unset)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'W',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is in the word and in the correct spot.')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.centerLeft,
                                width: 300,
                                height: 80,
                                child: Flex(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(child: TileBuilder.build('P', stats.GameColor.unset)),
                                    Flexible(
                                        child: TileBuilder.build('I', stats.GameColor.partial)),
                                    Flexible(child: TileBuilder.build('L', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('L', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('S', stats.GameColor.unset)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'I',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is in the word but in the wrong spot.')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.centerLeft,
                                width: 300,
                                height: 80,
                                child: Flex(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(child: TileBuilder.build('V', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('A', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('G', stats.GameColor.unset)),
                                    Flexible(child: TileBuilder.build('U', stats.GameColor.none)),
                                    Flexible(child: TileBuilder.build('E', stats.GameColor.unset)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'U',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is not in the word in any spot.')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(color: Colors.grey.shade800),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: RichText(
                                    textScaleFactor: 1.25,
                                    text: const TextSpan(
                                      text: 'A new ',
                                      children: [
                                        TextSpan(
                                            text: 'WORDLE',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: ' is available each day.')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ))
              ]))),
    );
  }
}
