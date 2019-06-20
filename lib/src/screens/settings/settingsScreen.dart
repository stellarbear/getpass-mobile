import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/screens/settings/tiles/aboutTile.dart';
import 'package:getpass/src/screens/settings/tiles/autoBrightnessTile.dart';
import 'package:getpass/src/screens/settings/tiles/brightnessTile.dart';
import 'package:getpass/src/screens/settings/tiles/clipboardTimerDurationTile.dart';
import 'package:getpass/src/screens/settings/tiles/clipboardWipeTile.dart';
import 'package:getpass/src/screens/settings/tiles/colorPickerAccentTile.dart';
import 'package:getpass/src/screens/settings/tiles/colorPickerPrimaryTile.dart';
import 'package:getpass/src/screens/settings/tiles/dataMigrateTile.dart';
import 'package:getpass/src/screens/settings/tiles/dataExportTile.dart';
import 'package:getpass/src/screens/settings/tiles/dataImportTile.dart';
import 'package:getpass/src/screens/settings/tiles/dataResetTile.dart';
import 'package:getpass/src/screens/settings/tiles/languageTile.dart';
import 'package:getpass/src/screens/settings/tiles/loginVisibilityTile.dart';
import 'package:getpass/src/screens/settings/tiles/scryptTile.dart';
import 'package:getpass/src/screens/settings/tiles/secretTimerDurationTile.dart';
import 'package:getpass/src/screens/settings/tiles/serviceVisibilityTile.dart';
import 'package:getpass/src/screens/settings/tiles/visualHashTile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          mainSection(context),
          importExportSection(context),
          colorPickerSection(context),
          coreTweakingSection(context),
          endSection(context),
        ],
      ),
    );
  }
}

Widget mainSection(
  BuildContext context,
) {
  final title = i18n.get(at: I18n.MainTileTitle);
  return Card(
    child: StreamBuilder(
      stream: settingsBloc.settingsStream,
      builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
        if (!settingsSnapshot.hasData) {
          return Text(i18n.get(at: I18n.Loading));
        }

        Settings settings = settingsSnapshot.data;
        return ExpansionTile(
          title: Text(title),
          //key: PageStorageKey(title),
          children: <Widget>[
            visualHashTile(settings),
            Divider(),
            loginVisibilityTile(settings),
            serviceVisibilityTile(settings),
            Divider(),
            secretTimerDurationTile(settings),
            clipboardTimerDurationTile(settings),
          ],
        );
      },
    ),
  );
}

Widget importExportSection(
  BuildContext context,
) {
  final title = i18n.get(at: I18n.ManagementTileTitle);
  return Card(
    child: ExpansionTile(
      title: Text(title),
      //key: PageStorageKey(title),
      children: <Widget>[
        dataImportTile(context),
        dataExportTile(context),
        Divider(),
        dataMigrateTile(context),
        Divider(),
        dataResetTile(context),
        clipboardWipeTile(context),
      ],
    ),
  );
}

Widget colorPickerSection(
  BuildContext context,
) {
  final title = i18n.get(at: I18n.ColorTileTitle);

  return Card(
    child: StreamBuilder(
      stream: colorThemeBloc.colorStream,
      builder: (context, AsyncSnapshot<ColorTheme> colorSnapshot) {
        if (!colorSnapshot.hasData) {
          return Text(i18n.get(at: I18n.Loading));
        }

        ColorTheme colorTheme = colorSnapshot.data;
        return ExpansionTile(
          title: Text(title),
          ////key: PageStorageKey(title),
          children: <Widget>[
            brightnessTile(colorTheme),
            autoBrightnessTile(colorTheme),
            Divider(),
            colorPickerPrimaryTile(context, colorTheme),
            colorPickerAccentTile(context, colorTheme),
          ],
        );
      },
    ),
  );
}

Widget coreTweakingSection(
  BuildContext context,
) {
  final title = i18n.get(at: I18n.ScryptTileTitle);

  return Card(
    child: StreamBuilder(
      stream: settingsBloc.settingsStream,
      builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
        if (!settingsSnapshot.hasData) {
          return Text(i18n.get(at: I18n.Loading));
        }

        Settings settings = settingsSnapshot.data;
        return ExpansionTile(
          title: Text(title),
          children: <Widget>[
            scryptTile(context, settings),
          ],
        );
      },
    ),
  );
}

Widget endSection(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(left: 8.0, right: 8.0),
    child: Column(
      ////key: PageStorageKey(title),
      children: <Widget>[
        languageTile(context),
        Divider(),
        aboutTile(context),
      ],
    ),
  );
}
