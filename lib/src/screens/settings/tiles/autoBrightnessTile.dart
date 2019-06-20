import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';

Widget autoBrightnessTile(ColorTheme colorTheme) {
  final autoBrightness = colorTheme.autoBrightness;

  return InkWell(
    child: ListTile(
      title: Text(
        i18n.get(at: I18n.AutoBrightness),
      ),
      trailing: Checkbox(
        value: autoBrightness,
        tristate: false,
        onChanged: (value) => colorThemeBloc.colorOnChange(colorTheme.copyWith(autoBrightness: value)),
      ),
    ),
    onTap: () {
      colorThemeBloc.colorOnChange(colorTheme.copyWith(autoBrightness: !autoBrightness));
    },
  );
}
