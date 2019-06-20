import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/clipboard.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/components/obscureTextField.dart';
import 'package:getpass/src/generator/generate.dart';
import 'package:getpass/src/infrastructure/login.dart';
import 'package:getpass/src/infrastructure/service.dart';
import 'package:getpass/src/bloc/progress.dart';

class MigrateModal extends StatefulWidget {
  @override
  State<MigrateModal> createState() => MigrateModalState();
}

class MigrateModalState extends State<MigrateModal> {
  String secret = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ObscureTextField(
            labelText: i18n.get(at: I18n.UpdateSecretText),
            onChange: (value) {
              setState(() {
                secret = value;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(i18n.get(at: I18n.Cancel)),
          onPressed: () => Navigator.pop(context),
        ),
        StreamBuilder(
          stream: settingsBloc.settingsStream,
          builder: (context, AsyncSnapshot<Settings> settingsSnapshot) {
            if (!settingsSnapshot.hasData) {
              return Text(i18n.get(at: I18n.Loading));
            }

            Settings settings = settingsSnapshot.data;
            final blockSizeFactor = settings.blockSizeFactor;
            final costFactor = settings.costFactor;

            return RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                i18n.get(at: I18n.OK),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (secret.length > 0)
                  ? () async {
                      progressBloc.progressOnChange(0.0);
                      Navigator.pushNamed(context, '/loading');

                      String Migrate = 'service\tlogin\tpass\n';
                      List<Service> services = serviceBloc.serviceList;
                      List<Login> logins = loginBloc.loginList;
                      double count =
                          (services.length * logins.length).toDouble();
                      int current = 0;

                      for (Service service in services) {
                        for (Login login in logins) {
                          final pass = await compute(
                            generatePasswordImplementation,
                            GenerateHandle(
                              login: login,
                              service: service,
                              secret: secret,
                              blockSizeFactor: blockSizeFactor,
                              costFactor: costFactor,
                            ),
                          );

                          progressBloc.progressOnChange(++current / count);

                          Migrate +=
                              '${service.value}\t${login.value}\t$pass\n';
                        }
                      }

                      progressBloc.progressOnChange(1.0);
                      clipboardBloc.setText(text: Migrate);
                      Navigator.pop(context, true);
                      Future.delayed(const Duration(milliseconds: 256), () {
                        progressBloc.progressOnChange(0.0);
                        notifyBloc.notifyOnChange(
                            i18n.get(at: I18n.NotifyPasswordsMigrated));
                      });
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }
}
