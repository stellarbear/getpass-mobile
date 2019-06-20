import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/clipboard.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:getpass/src/bloc/progress.dart';
import 'package:getpass/src/bloc/secret.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';

Widget generatePasswordTile(context) {
  return StreamBuilder(
    stream: loginBloc.selectedLoginStream,
    builder: (loginContext, AsyncSnapshot<Login> loginSnapshot) {
      if (!loginSnapshot.hasData) {
        return buttonTemplate(
          context,
          i18n.get(
            at: I18n.GenerateButtonSelectLogin,
          ),
          null,
        );
      }

      return StreamBuilder(
        stream: serviceBloc.selectedServiceStream,
        builder: (serviceContext, AsyncSnapshot<Service> serviceSnapshot) {
          if (!serviceSnapshot.hasData) {
            return buttonTemplate(
              context,
              i18n.get(
                at: I18n.GenerateButtonSelectService,
              ),
              null,
            );
          }

          return StreamBuilder(
            stream: secretBloc.timerStream,
            builder: (secretContext, secretSnapshot) {
              if ((!secretSnapshot.hasData) || (secretSnapshot.data == 0)) {
                return buttonTemplate(
                  context,
                  i18n.get(
                    at: I18n.GenerateButtonUpdateSecret,
                  ),
                  null,
                );
              }

              return StreamBuilder(
                stream: settingsBloc.settingsStream,
                builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
                  if (!settingsSnapshot.hasData) {
                    return Text(i18n.get(at: I18n.Loading));
                  }

                  Settings settings = settingsSnapshot.data;
                  final clipboardTimerDuration =
                      settings.clipboardTimerDuration;
                  final blockSizeFactor = settings.blockSizeFactor;
                  final costFactor = settings.costFactor;
                  return buttonTemplate(
                    context,
                    i18n.get(at: I18n.GenerateButtonActive),
                    () async {
                      try {
                        Navigator.pushNamed(context, '/loading');
                        progressBloc.progressOnChange(-1.0);

                        String _password = await secretBloc.generatePassword(
                          costFactor: costFactor,
                          blockSizeFactor: blockSizeFactor,
                          login: loginSnapshot.data,
                          service: serviceSnapshot.data,
                        );

                        Navigator.pop(context);

                        clipboardBloc.setText(text: _password);

                        clipboardBloc.restartTimer(
                            duration: clipboardTimerDuration);

                        Future.delayed(const Duration(milliseconds: 256), () {
                          notifyBloc.notifyOnChange(
                              i18n.get(at: I18n.NotifyPasswordGenerated));
                        });

                        assert(() {
                          print(_password);
                          return true;
                        }());
                      } catch (ex) {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 256), () {
                          notifyBloc.notifyOnChange(
                              i18n.get(at: I18n.NotifyIncompatibleParams));
                        });
                      }
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

Widget buttonTemplate(BuildContext context, String text, Function() onPressed) {
  return Container(
    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
    child: RaisedButton(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).primaryColor,
      onPressed: onPressed,
    ),
  );
}
