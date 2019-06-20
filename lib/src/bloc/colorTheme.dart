import 'package:flutter/material.dart';
import 'package:getpass/src/infrastructure/storage.dart';
import 'package:rxdart/rxdart.dart';

class ColorTheme {
  bool autoBrightness;
  int primaryColor;
  int accentColor;
  int brightness;

  static bool autoBrightnessDefault = false;
  static Color accentColorDefault = Colors.orange[600];
  static Color primaryColorDefault = Colors.indigo[400];
  static Brightness brightnessDefault = Brightness.light;

  Color get getAccentColor => Color(accentColor);
  Color get getPrimaryColor => Color(primaryColor);
  Brightness get getBrightness =>
      brightness == Brightness.dark.index ? Brightness.dark : Brightness.light;

  ColorTheme({
    this.brightness,
    this.accentColor,
    this.primaryColor,
    this.autoBrightness,
  });

  ColorTheme.seed()
      : accentColor = storage.getItem(
            key: storageKey.accentColor,
            defaultValue: accentColorDefault.value),
        primaryColor = storage.getItem(
            key: storageKey.primaryColor,
            defaultValue: primaryColorDefault.value),
        brightness = storage.getItem(
            key: storageKey.brightness, defaultValue: brightnessDefault.index),
        autoBrightness = storage.getItem(
            key: storageKey.autoBrightness,
            defaultValue: autoBrightnessDefault);

  void save() async {
    await storage.setItem(
        key: storageKey.autoBrightness, value: autoBrightness);
    await storage.setItem(key: storageKey.brightness, value: this.brightness);
    await storage.setItem(key: storageKey.accentColor, value: this.accentColor);
    await storage.setItem(
        key: storageKey.primaryColor, value: this.primaryColor);
  }

  ColorTheme copyWith({
    int brightness,
    int accentColor,
    int primaryColor,
    bool autoBrightness,
  }) {
    return ColorTheme(
      brightness: brightness ?? this.brightness,
      accentColor: accentColor ?? this.accentColor,
      primaryColor: primaryColor ?? this.primaryColor,
      autoBrightness: autoBrightness ?? this.autoBrightness,
    );
  }

  static ColorTheme byDefault() => new ColorTheme(
        brightness: brightnessDefault.index,
        autoBrightness: autoBrightnessDefault,
        accentColor: accentColorDefault.value,
        primaryColor: primaryColorDefault.value,
      );

  void adjustBrightness() {
    final hour = DateTime.now().hour;
    brightness = (hour >= 6 && hour <= 21)
        ? Brightness.light.index
        : Brightness.dark.index;
  }

  static String colorToString(Color input) =>
      '#' + input.value.toRadixString(16).substring(2);

  static int stringToColorInt(String input) =>
      int.parse(input.substring(1, 7), radix: 16) + 0xFF000000;

  factory ColorTheme.fromJson(Map<String, dynamic> json) {
    return ColorTheme(
      brightness: json['brightness'],
      accentColor: stringToColorInt(json['accentColor']),
      primaryColor: stringToColorInt(json['primaryColor']),
      autoBrightness: json['autoBrightness'],
    );
  }

  Map<String, dynamic> toJson() => {
        'brightness': brightness,
        'accentColor': colorToString(getAccentColor),
        'primaryColor': colorToString(getPrimaryColor),
        'autoBrightness': autoBrightness,
      };
}

class ColorThemeBloc {
  BehaviorSubject<ColorTheme> _colorController;
  Observable<ColorTheme> get colorStream => _colorController.stream;
  void colorOnChange(ColorTheme value) {
    _colorController.sink.add(value);
    value.save();
  }

  init() async {
    _colorController =
        BehaviorSubject<ColorTheme>(seedValue: ColorTheme.seed());
  }

  dispose() {
    _colorController.close();
  }
}

final colorThemeBloc = ColorThemeBloc();
