import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/domain.dart' as domain;
import 'package:flutterdle/helpers/tile_builder.dart';

class HowTo extends StatelessWidget {
  final void Function(domain.Dialog dialog, {bool show}) close;

  const HowTo(this.close, this._settings, {Key? key}) : super(key: key);

  final Settings _settings;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.black12,
      child: BlockSemantics(
        blocking: true,
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
                        child: Column(children: [
                          Row(
                            children: [
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.only(left: 48),
                                child: Text(
                                  "HOW TO PLAY",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () => close(domain.Dialog.help, show: false),
                                  child: Semantics(
                                    label: 'tap to close help',
                                    child: const ExcludeSemantics(
                                        excluding: true,
                                        child: Text("X", style: TextStyle(fontSize: 20))),
                                  ))
                            ],
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text.rich(
                                    TextSpan(
                                      text: 'Guess the ',
                                      children: [
                                        TextSpan(
                                            text: 'FLUTTERDLE',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' in six tries.')
                                      ],
                                    ),
                                    textScaleFactor: 1.25),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: Text.rich(TextSpan(
                                text:
                                    'Each guess must be a valid five-letter word. Hit the enter button to submit.')),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                            child: Text.rich(
                                TextSpan(
                                    text:
                                        'After each guess, the color of the tiles will change to show how close your guess was to the word.'),
                                textScaleFactor: 1.25),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(color: Colors.grey.shade800),
                          ),
                          Row(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text.rich(
                                      TextSpan(
                                          text: "Examples",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                      textScaleFactor: 1.25)),
                            ],
                          ),
                          Row(
                            children: [
                              Semantics(
                                label: 'Example word weary with W as an exact match',
                                child: Container(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  alignment: Alignment.centerLeft,
                                  width: 300,
                                  height: 80,
                                  child: Flex(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                          child: TileBuilder.build(
                                              Letter(value: 'W', color: GameColor.correct),
                                              _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'E'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'A'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'R'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'Y'), _settings)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text.rich(
                                    TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'W',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is in the word and in the correct spot.')
                                      ],
                                    ),
                                    textScaleFactor: 1.25),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Semantics(
                                label: 'Example word pills with I as a partial match',
                                child: Container(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  alignment: Alignment.centerLeft,
                                  width: 300,
                                  height: 80,
                                  child: Flex(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'P'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(
                                              Letter(value: 'I', color: GameColor.present),
                                              _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'L'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'L'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'S'), _settings)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text.rich(
                                    TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'I',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is in the word but in the wrong spot.')
                                      ],
                                    ),
                                    textScaleFactor: 1.25),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Semantics(
                                label: 'Example word vague with U not matching',
                                child: Container(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  alignment: Alignment.centerLeft,
                                  width: 300,
                                  height: 80,
                                  child: Flex(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    direction: Axis.horizontal,
                                    children: [
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'V'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'A'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'G'), _settings)),
                                      Flexible(
                                          child: TileBuilder.build(
                                              Letter(value: 'U', color: GameColor.absent),
                                              _settings)),
                                      Flexible(
                                          child: TileBuilder.build(Letter(value: 'E'), _settings)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text.rich(
                                    TextSpan(
                                      text: 'The letter ',
                                      children: [
                                        TextSpan(
                                            text: 'U',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is not in the word in any spot.')
                                      ],
                                    ),
                                    textScaleFactor: 1.25),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(color: Colors.grey.shade800),
                          ),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text.rich(
                                    TextSpan(
                                      text: 'A new ',
                                      children: [
                                        TextSpan(
                                            text: 'FLUTTERDLE',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: ' is available each day.')
                                      ],
                                    ),
                                    textScaleFactor: 1.25),
                              ),
                            ],
                          ),
                        ]),
                      ))
                ]))),
      ),
    );
  }
}
