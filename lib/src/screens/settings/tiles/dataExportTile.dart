import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as Enc;
import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/clipboard.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/login.dart';
import 'package:getpass/src/bloc/notify.dart';
import 'package:getpass/src/bloc/service.dart';
import 'package:getpass/src/bloc/settings.dart';
import 'package:getpass/src/infrastructure/export.dart';
import 'package:getpass/src/screens/settings/modals/exportModal.dart';

Widget dataExportTile(BuildContext context) {
  return StreamBuilder(
    stream: serviceBloc.serviceStream,
    builder: (context, serviceSnapshot) {
      return StreamBuilder(
        stream: loginBloc.loginStream,
        builder: (context, loginSnapshot) {
          return StreamBuilder(
            stream: settingsBloc.settingsStream,
            builder: (context, settingsSnapshot) {
              return StreamBuilder(
                stream: colorThemeBloc.colorStream,
                builder: (context, themeSnapshot) {
                  if (!serviceSnapshot.hasData ||
                      !loginSnapshot.hasData ||
                      !settingsSnapshot.hasData ||
                      !themeSnapshot.hasData) {
                    return Container();
                  }

                  return InkWell(
                    onTap: () async {
                      final returnValue = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return exportModal(context);
                        },
                      );

                      if (returnValue != null) {
                        final export = ExportData(
                            services: serviceSnapshot.data,
                            logins: loginSnapshot.data,
                            theme: themeSnapshot.data,
                            settings: settingsSnapshot.data);

                        final exportString = json.encode(export.toJson());

                        final keyVal = sha256
                            .convert(utf8.encode(returnValue))
                            .toString()
                            .substring(0, 32);

                        final key = Enc.Key.fromUtf8(keyVal);
                        final iv = Enc.IV.fromLength(16);

                        final encrypter =
                            Enc.Encrypter(Enc.AES(key, mode: Enc.AESMode.cbc));

                        final encrypted =
                            encrypter.encrypt(exportString, iv: iv);
                        final decrypted = encrypter.decrypt(encrypted, iv: iv);

                        clipboardBloc.setText(text: encrypted.base64);

                        notifyBloc.notifyOnChange(
                            i18n.get(at: I18n.NotifyExportSucceed));
                      }
                    },
                    child: ListTile(
                      title: Text(i18n.get(at: I18n.ExportDataTitle)),
                      trailing: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.cloud_upload,
                            color: Colors.white,
                          )),
                    ),
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
