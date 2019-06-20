import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';

Widget resetConfirmationModal(BuildContext context) {
  return AlertDialog(
    content: Text(i18n.get(at: I18n.ResetDataPlaceholder)),
    actions: <Widget>[
      FlatButton(
        child: Text(i18n.get(at: I18n.Cancel)),
        onPressed: () => Navigator.pop(context),
      ),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          i18n.get(at: I18n.OK),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context, true),
      )
    ],
  );
}
