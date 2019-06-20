import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/components/restartableApp.dart';
import 'package:getpass/src/screens/settings/modals/resetConfirmationModal.dart';

Widget dataResetTile(BuildContext context) {
  return InkWell(
    onTap: () async {
      final returnValue = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return resetConfirmationModal(context);
        },
      );

      if (returnValue != null) {
        settingsBloc.reset();
        serviceBloc.reset();
        loginBloc.reset();

        RestartableApp.restartApp(context);
      }
    },
    child: ListTile(
      title: Text(i18n.get(at: I18n.ResetDataTitle)),
      trailing: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          )),
    ),
  );
}
