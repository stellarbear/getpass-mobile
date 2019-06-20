import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/obscure.dart';
import 'package:getpass/src/infrastructure/service.dart';

Widget serviceTile(context) {
  return Container(
    margin: EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(4.0),
            child: Text(i18n.get(at: I18n.ServiceTileTitle),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => Navigator.pushNamed(context, '/edit/service'),
            title: StreamBuilder(
              stream: serviceBloc.selectedServiceStream,
              builder:
                  (context, AsyncSnapshot<Service> selectedServiceSnapshot) {
                final text = (!selectedServiceSnapshot.hasData)
                    ? i18n.get(at: I18n.ServiceTileMock)
                    : selectedServiceSnapshot.data.value;

                return StreamBuilder(
                  stream: settingsBloc.settingsStream,
                  builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
                    if (!settingsSnapshot.hasData) {
                      return Text(i18n.get(at: I18n.Loading));
                    }

                    Settings settings = settingsSnapshot.data;
                    final obscureValue = settings.serviceVisibility;
                    
                    final obscuredText = selectedServiceSnapshot.hasData
                        ? obscure(text, obscureValue)
                        : text;

                    return Opacity(
                      opacity: (selectedServiceSnapshot.hasData ? 1.0 : 0.4),
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
                Text(i18n.get(at: I18n.ServiceTileButton)),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
