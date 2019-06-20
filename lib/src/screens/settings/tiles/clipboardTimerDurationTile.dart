import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';

Widget clipboardTimerDurationTile(Settings settings) {
  final clipboardTimerDuration = settings.clipboardTimerDuration;

  int minutes = (clipboardTimerDuration / 60).floor();
  int seconds = clipboardTimerDuration - minutes * 60;
  String humanReadable =
      '$minutes ${i18n.get(at: I18n.Min)} $seconds ${i18n.get(at: I18n.Sec)}';

  return ListTile(
    title: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(i18n.get(at: I18n.ClipboardExpirationTitle)),
        Text(humanReadable),
      ],
    ),
    subtitle: Slider(
      min: 15.0,
      max: 180.0,
      value: clipboardTimerDuration.toDouble(),
      divisions: 11,
      onChanged: (double value) {
        settingsBloc.settingsOnChange(
            settings.copyWith(clipboardTimerDuration: value.toInt()));
      },
    ),
  );
}
