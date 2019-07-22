import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/secret.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/components/obscureTextField.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

Widget updateSecretsModal(BuildContext context) {
  return StreamBuilder(
    stream: secretBloc.secretStream,
    builder: (context, secretSnapshot) {
      String rawSvg =
          Jdenticon.toSvg(secretSnapshot.hasData ? secretSnapshot.data : '');

      return StreamBuilder(
        stream: settingsBloc.settingsStream,
        builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
          if (!settingsSnapshot.hasData) {
            return Text(i18n.get(at: I18n.Loading));
          }

          Settings settings = settingsSnapshot.data;
          bool showVisualHash = settings.visualHash;

          return AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: 8.0, top: 16.0, left: 16.0, right: 16.0),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showVisualHash
                    ? SvgPicture.string(
                        rawSvg,
                        fit: BoxFit.contain,
                        width: 128.0,
                        height: 128.0,
                      )
                    : Container(),
                Flexible(
                  child: ObscureTextField(
                    labelText: i18n.get(at: I18n.UpdateSecretText),
                    errorText:
                        secretSnapshot.hasError ? secretSnapshot.error : null,
                    onChange: secretBloc.secretOnChange,
                  ),
                ),
              ],
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
                onPressed:
                    secretSnapshot.hasData && secretBloc.secretValue.length > 0
                        ? () => Navigator.pop(context, true)
                        : null,
              ),
            ],
          );
        },
      );
    },
  );
}
