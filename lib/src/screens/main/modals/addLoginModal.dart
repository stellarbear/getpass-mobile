import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/infrastructure/login.dart';

Widget addLoginModal(
    BuildContext context, AsyncSnapshot<Login> newLoginSnapshot) {
  Login newLogin =
      newLoginSnapshot.hasData ? newLoginSnapshot.data : Login.byDefault();

  return AlertDialog(
    content: TextField(
      autofocus: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        hintText: i18n.get(at: I18n.AddNewLoginPlaceholder),
        labelText: i18n.get(at: I18n.AddNewLoginText),
        errorText: newLoginSnapshot.error,
        suffixIcon: Icon(Icons.account_circle),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).primaryTextTheme.display1.color),
        ),
      ),
      onChanged: (value) =>
          loginBloc.newLoginOnChange(newLogin.copyWith(value: value)),
    ),
    actions: <Widget>[
      FlatButton(
          child: Text(i18n.get(at: I18n.Cancel)),
          onPressed: () => Navigator.pop(context)),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          i18n.get(at: I18n.OK),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: (!newLoginSnapshot.hasError && newLogin.value.length > 0)
            ? () {
                loginBloc.newLoginOnChange(newLogin);

                Navigator.pop(
                  context,
                  newLogin,
                );
              }
            : null,
      )
    ],
  );
}
