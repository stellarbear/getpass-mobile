import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/screens/settings/modals/aboutModal.dart';

Widget aboutTile(BuildContext context) {
  return ListTile(
    onTap: () async {
      await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return aboutModal(context);
        },
      );
    },
    title: Text(
      i18n.get(at: I18n.AboutTileTitle),
      textAlign: TextAlign.left,
    ),
    subtitle: FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        String info = i18n.get(at: I18n.Loading);
        if (snapshot.hasData) {
          info = snapshot.data.version;
        }

        return Text(info);
      },
    ),
    trailing: Icon(Icons.info),
  );
}
