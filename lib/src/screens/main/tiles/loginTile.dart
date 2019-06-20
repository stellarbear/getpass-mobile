import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/obscure.dart';

Widget loginTile(context) {
  return Container(
    margin: EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(4.0),
            child: Text(i18n.get(at: I18n.LoginTileTitle),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => Navigator.pushNamed(context, '/edit/login'),
            title: StreamBuilder(
              stream: loginBloc.selectedLoginStream,
              builder: (context, AsyncSnapshot<Login> selectedLoginSnapshot) {
                final text = (!selectedLoginSnapshot.hasData)
                    ? i18n.get(at: I18n.LoginTileMock)
                    : selectedLoginSnapshot.data.value;

                return StreamBuilder(
                  stream: settingsBloc.settingsStream,
                  builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
                    if (!settingsSnapshot.hasData) {
                      return Text(i18n.get(at: I18n.Loading));
                    }

                    Settings settings = settingsSnapshot.data;
                    final obscureValue = settings.loginVisibility;

                    final obscuredText = selectedLoginSnapshot.hasData
                        ? obscure(text, obscureValue)
                        : text;

                    return Opacity(
                      opacity: (selectedLoginSnapshot.hasData ? 1.0 : 0.4),
                      child: Text(
                        obscuredText,
                        textAlign: TextAlign.left,
                      ),
                    );
                  },
                );
              },
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.cached),
                Text(i18n.get(at: I18n.LoginTileButton)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
