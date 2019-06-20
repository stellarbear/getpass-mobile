import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/exportImport.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/components/obscureTextField.dart';

Widget importModal(BuildContext context) {
  return StreamBuilder(
    stream: exportImportBloc.importStream,
    builder: (context, importSnapshot) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ObscureTextField(
              autofocus: false,
              autocorrect: false,
              labelText: i18n.get(at: I18n.ImportKeyPlaceholder),
              onChange: exportImportBloc.importKeyOnChange,
            ),
            TextField(
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  labelText: i18n.get(at: I18n.ImportDataPlaceholder),
                  errorText: importSnapshot.error,
                  suffixIcon: Icon(Icons.import_export)),
              onChanged: exportImportBloc.importDataOnChange,
            ),
          ],
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
            onPressed: !importSnapshot.hasError
                ? () => Navigator.pop(context, importSnapshot.data)
                : null,
          )
        ],
      );
    },
  );
}
