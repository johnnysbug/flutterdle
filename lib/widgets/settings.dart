import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdle/domain.dart';
import 'package:flutterdle/domain.dart' as domain;
import 'package:flutterdle/services/settings_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsWidget extends StatefulWidget {
  final void Function(domain.Dialog, {bool show}) close;
  final StreamController streamController;
  final Settings _settings;
  final PackageInfo _packageInfo;

  const SettingsWidget(this.close, this.streamController, this._settings, this._packageInfo, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    var keyboardOptions = KeyboardLayout.values.map((k) => DropdownMenuItem(
          child: Text(k.name),
          value: k,
        )).toList();
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
                                      onPressed: () =>
                                          widget.close(domain.Dialog.settings, show: false),
                                      child: Semantics(
                                        label: 'Close settings.',
                                        child: const ExcludeSemantics(
                                            excluding: true,
                                            child: Text('X', style: TextStyle(fontSize: 20))),
                                      ))
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: Center(
                                    child: Text(
                                  "SETTINGS",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                              ),
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
                                      title: const Text("Dark Mode",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
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
                                      subtitle: const Text("For improved color vision"),
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
                                    ListTile(
                                      title: const Text(
                                        'Keyboard Layout',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      trailing: Padding(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: DropdownButton(
                                          value: widget._settings.keyboardLayout,
                                          items: keyboardOptions,
                                          onChanged: (KeyboardLayout? layout) {
                                            widget.streamController.add(widget._settings);
                                            widget._settings.keyboardLayout = layout!;
                                            SettingsService().save(widget._settings);
                                            setState(() {
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ).toList()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Version ${widget._packageInfo.version} - Build ${widget._packageInfo.buildNumber}'),
                              )
                            ])))
                  ]))),
        ));
  }
}
