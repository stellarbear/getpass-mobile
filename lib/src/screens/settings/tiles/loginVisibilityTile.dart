import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';

Widget loginVisibilityTile(Settings settings) {
  final loginVisibility = settings.loginVisibility;

  String humanReadable = (loginVisibility == 8)
      ? i18n.get(at: I18n.FullyVisible)
      : '$loginVisibility ${i18n.get(at: I18n.LoginVisibilityEnding)}';

  return ListTile(
    title: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(i18n.get(at: I18n.LoginVisibilityTitle)),
        Text(humanReadable),
      ],
    ),
    subtitle: Slider(
      min: 0.0,
      max: 8.0,
      value: loginVisibility.toDouble(),
      divisions: 8,
      onChanged: (double value) {
        settingsBloc.settingsOnChange(
            settings.copyWith(loginVisibility: value.toInt()));
      },
    ),
  );
}
