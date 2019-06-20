import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';

ThemeData themeBuilder({ColorTheme colorTheme}) {
  return ThemeData(
    // Define the default Brightness and Colors
    brightness: colorTheme.getBrightness,
    primaryColor: colorTheme.getPrimaryColor,
    accentColor: colorTheme.getAccentColor,

    // Define the default Font Family
    fontFamily: 'Montserrat',

    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}
