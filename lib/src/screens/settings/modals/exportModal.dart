import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/exportImport.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/components/obscureTextField.dart';

Widget exportModal(BuildContext context) {
  return StreamBuilder(
    stream: exportImportBloc.exportKeyStream,
    builder: (context, exportSnapshot) {
      return AlertDialog(
        content: ObscureTextField(
          autofocus: true,
          autocorrect: false,
          labelText: i18n.get(at: I18n.ExportKeyPlaceholder),
          onChange: exportImportBloc.exportOnChange,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(i18n.get(at: I18n.Cancel)),
            onPressed: () => Navigator.pop(context),
          ),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              i18n.get(at: I18n.Update),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context, exportSnapshot.data),
          )
        ],
      );
    },
  );
}
