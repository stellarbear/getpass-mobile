import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';

Widget serviceVisibilityTile(Settings settings) {
  final serviceVisibility = settings.serviceVisibility;
  String humanReadable = (serviceVisibility == 8)
      ? i18n.get(at: I18n.FullyVisible)
      : '$serviceVisibility ${i18n.get(at: I18n.ServiceVisibilityEnding)}';

  return ListTile(
    title: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(i18n.get(at: I18n.ServiceVisibilityTitle)),
        Text(humanReadable),
      ],
    ),
    subtitle: Slider(
      min: 0.0,
      max: 8.0,
      value: serviceVisibility.toDouble(),
      divisions: 8,
      onChanged: (double value) {
        settingsBloc.settingsOnChange(
            settings.copyWith(serviceVisibility: value.toInt()));
      },
    ),
  );
}
