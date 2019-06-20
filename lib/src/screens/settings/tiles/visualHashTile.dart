import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';

Widget visualHashTile(Settings settings) {
  final visualHash = settings.visualHash;

  return InkWell(
    child: ListTile(
      title: Text(
        i18n.get(at: I18n.VisualHash),
      ),
      trailing: Checkbox(
        value: visualHash,
        tristate: false,
        onChanged: (value) =>
            settingsBloc.settingsOnChange(settings.copyWith(visualHash: value)),
      ),
    ),
    onTap: () {
      settingsBloc.settingsOnChange(settings.copyWith(visualHash: !visualHash));
    },
  );
}
