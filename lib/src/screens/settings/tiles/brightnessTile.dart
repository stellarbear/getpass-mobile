import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';

Widget brightnessTile(ColorTheme colorTheme) {
  final Brightness selectedBrightness = colorTheme.getBrightness;
  final humanReadable = selectedBrightness == Brightness.dark
      ? i18n.get(at: I18n.BrightnessDark)
      : i18n.get(at: I18n.BrightnessLight);

  return InkWell(
    onTap: () async {
      final Brightness newBrightness = (selectedBrightness == Brightness.light)
          ? Brightness.dark
          : Brightness.light;

      colorThemeBloc
          .colorOnChange(colorTheme.copyWith(brightness: newBrightness.index));
    },
    child: ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(i18n.get(at: I18n.BrightnessTitle)),
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: Text(humanReadable),
          ),
        ],
      ),
    ),
  );
}
