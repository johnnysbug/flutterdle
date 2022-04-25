import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/domain.dart' as domain;
import 'package:flutterdle/services/settings_service.dart';

class SettingsWidget extends StatefulWidget {
  final void Function(domain.Dialog, {bool show}) close;
  final StreamController streamController;
  final Settings _settings;

  const SettingsWidget(this.close, this.streamController, this._settings, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
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
                                      onPressed: () => widget.close(domain.Dialog.settings, show: false),
                                      child: Semantics(
                                        label: 'tap to close settings',
                                        child: const ExcludeSemantics(
                                          excluding: true,
                                          child: Text('X', style: TextStyle(fontSize: 20))),
                                      ))
                                ],
                              ),
                              const Center(
                                  child: Text(
                                "SETTINGS",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                              Expanded(
                                child: ListView(
                                    children: ListTile.divideTiles(
                                  context: context,
                                  tiles: [
                                    SwitchListTile(
                                      subtitle: const Text(
                                          "Any revealed hints must be used in subsequent guesses"),
                                      title: const Text("Hard Mode",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                      value: widget._settings.isHardMode,
                                      onChanged: (bool value) {
                                        widget._settings.isHardMode = value;
                                        SettingsService().save(widget._settings);
                                        widget.streamController.add(widget._settings);
                                        setState(() {
                                          widget._settings.isHardMode = value;
                                        });
                                      },
                                    ),
                                    SwitchListTile(
                                      title: const Text(
                                        "Dark Mode",
                                        style: TextStyle(
                                            fontSize: 18,
                                          )
                                      ),
                                      
                                      value: widget._settings.isDarkMode,
                                      onChanged: (bool value) {
                                        widget._settings.isDarkMode = value;
                                        SettingsService().save(widget._settings);
                                        widget.streamController.add(widget._settings);
                                        setState(
                                          () {
                                            widget._settings.isDarkMode = value;
                                          },
                                        );
                                      },
                                    ),
                                    SwitchListTile(
                                      subtitle: const Text(
                                          "For improved color vision"),
                                      title: const Text("High Contrast Mode",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                      value: widget._settings.isHighContrast,
                                      onChanged: (bool value) {
                                        widget._settings.isHighContrast = value;
                                        SettingsService().save(widget._settings);
                                        widget.streamController.add(widget._settings);
                                        setState(() {
                                          widget._settings.isHighContrast = value;
                                        });
                                      },
                                    ),
                                  ],
                                ).toList()),
                              ),
                            ])))
                  ]))),
        ));
  }
}
