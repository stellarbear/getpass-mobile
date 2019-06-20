import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/secret.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/screens/main/modals/updateSecretsModal.dart';

Widget secretsTile(context) {
  return Container(
    margin: EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(4.0),
            child: Text(i18n.get(at: I18n.SecretTileTitle),
                style: TextStyle(fontSize: 20)),
          ),
        ),
        Card(
          child: StreamBuilder(
            stream: settingsBloc.settingsStream,
            builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
              if (!settingsSnapshot.hasData) {
                return Text(i18n.get(at: I18n.Loading));
              }

              Settings settings = settingsSnapshot.data;
              final secretTimerDuration = settings.secretTimerDuration;

              return StreamBuilder(
                stream: secretBloc.timerStream,
                builder: (timerValueContext, timerValueSnapshot) {
                  final humanReadable = (!timerValueSnapshot.hasData ||
                          timerValueSnapshot.data == 0)
                      ? i18n.get(at: I18n.SecretTileMock)
                      : '${timerValueSnapshot.data} ${i18n.get(at: I18n.SecretTimeLeft)}';
                  final progressValue = ((timerValueSnapshot.data == null) ||
                          (secretTimerDuration == null))
                      ? 0.0
                      : timerValueSnapshot.data / secretTimerDuration;

                  return ListTile(
                    onTap: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          secretBloc.resetTimer();

                          return updateSecretsModal(context);
                        },
                      );

                      if (result != null) {
                        secretBloc.restartTimer(
                            duration: secretTimerDuration);
                      }
                    },
                    title: Opacity(
                      opacity: ((timerValueSnapshot.data != 0) ? 1.0 : 0.4),
                      child: Text(
                        humanReadable,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    subtitle: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      value: progressValue,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.update),
                        Text(i18n.get(at: I18n.SecretTileButton)),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
