import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/clipboard.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/notify.dart';

Widget clipboardWipeTile(
  BuildContext context,
) {
  return InkWell(
    onTap: () async {
      clipboardBloc.setText(text: '');
      notifyBloc.notifyOnChange(i18n.get(at: I18n.NotifyClipboardWiped));
    },
    child: ListTile(
      title: Text(i18n.get(at: I18n.WipeClipboardTitle)),
      trailing: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.clear,
            color: Colors.white,
          )),
    ),
  );
}
