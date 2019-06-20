import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/components/restartableApp.dart';
import 'package:getpass/src/infrastructure/export.dart';
import 'package:getpass/src/screens/settings/modals/importModal.dart';

Widget dataImportTile(BuildContext context) {
  return InkWell(
    onTap: () async {
      final returnValue = await showDialog<ExportData>(
        context: context,
        builder: (BuildContext context) {
          return importModal(context);
        },
      );

      if (returnValue != null) {
        final data = returnValue;

        serviceBloc.reset();
        loginBloc.reset();

        data.services.forEach((service) => serviceBloc.serviceAdd(service));
        data.logins.forEach((logins) => loginBloc.loginAdd(logins));
        settingsBloc.settingsOnChange(data.settings);
        colorThemeBloc.colorOnChange(data.theme);

        RestartableApp.restartApp(context);
        notifyBloc.notifyOnChange(i18n.get(at: I18n.NotifyImportSucceed));
      }
    },
    child: ListTile(
      title: Text(i18n.get(at: I18n.ImportDataTitle)),
      trailing: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.cloud_download,
            color: Colors.white,
          )),
    ),
  );
}
