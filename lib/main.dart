import 'package:flutter/material.dart';
import 'package:getpass/src/app.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/progress.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/components/restartableApp.dart';
import 'package:getpass/src/infrastructure/storage.dart';

//  flutter build apk --target-platform=android-arm64
//  FOR SLOW
//  flutter run --release --target-platform=android-arm

//  flutter packages pub run flutter_launcher_icons:main
void main() async {
  //  debugPaintSizeEnabled = true;

  await storage.init();

  i18n.init();
  loginBloc.init();
  serviceBloc.init();
  progressBloc.init();
  settingsBloc.init();
  colorThemeBloc.init();

  settingsBloc.init();
  runApp(
    RestartableApp(
      child: App(),
    ),
  );
}
