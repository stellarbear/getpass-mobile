import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/screens/settings/modals/aboutModal.dart';

Widget firstLaunchWrapper({Widget child}) {
  return StreamBuilder(
    stream: settingsBloc.settingsStream,
    builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
      if (!settingsSnapshot.hasData) {
        return Text(i18n.get(at: I18n.Loading));
      }

      Settings settings = settingsSnapshot.data;
      bool launchInfo = settings.firstBoot;

      if (launchInfo) {
        Future.delayed(
          Duration.zero,
          () => showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return aboutModal(context);
                },
              ),
        );

        settingsBloc.settingsOnChange(settings.copyWith(firstBoot: false));
      }

      return child;
    },
  );
}
