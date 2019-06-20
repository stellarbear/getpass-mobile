import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';

Widget languageModal(BuildContext context) {
  final codes = I18nLangCode.values;

  final languageList = codes
      .map(
        (I18nLangCode code) => ListTile(
              title: Text(i18n.getLanguageMeta(code: code).name),
              onTap: () => Navigator.pop(context, code),
              trailing: Image.asset(
                'assets/localization/${i18n.getLanguageMeta(code: code).assetPath}',
                width: 32,
                height: 32,
              ),
            ),
      )
      .toList();

  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: languageList,
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(i18n.get(at: I18n.Cancel)),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}
