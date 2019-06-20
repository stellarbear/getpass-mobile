import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:getpass/src/screens/settings/modals/migrateModal.dart';

Widget dataMigrateTile(BuildContext context) {
  return InkWell(
    onTap: () async {
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return MigrateModal();
        },
      );
    },
    child: ListTile(
      title: Text(i18n.get(at: I18n.MigratePasswordsTitle)),
      trailing: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.subject,
            color: Colors.white,
          )),
    ),
  );
}
