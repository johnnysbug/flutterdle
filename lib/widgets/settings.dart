import 'dart:async';

import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  final Function close;
  final StreamController streamController;
  final bool isDarkTheme;

  const SettingsWidget(this.close, this.streamController, this.isDarkTheme, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        shadowColor: Colors.black12,
        child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
                width: 500,
                height: 500,
                child: Stack(children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                          width: 410,
                          height: 500,
                          child: Column(children: [
                            Row(
                              children: [
                                const Spacer(),
                                TextButton(
                                    onPressed: () => widget.close(),
                                    child: const Text("X", style: TextStyle(fontSize: 20)))
                              ],
                            ),
                            const Center(
                                child: Text(
                              "SETTINGS",
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
                                      const Text(
                                        "Dark Theme",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Spacer(),
                                      Switch(
                                        value: _isDarkTheme,
                                        onChanged: (value) {
                                          widget.streamController
                                              .add(value ? ThemeMode.dark : ThemeMode.light);
                                          setState(() {
                                            _isDarkTheme = value;
                                          });
                                        },
                                        activeTrackColor: Colors.lightGreenAccent,
                                        activeColor: Colors.green,
                                      )
                                    ]))
                          ])))
                ]))));
  }
}
