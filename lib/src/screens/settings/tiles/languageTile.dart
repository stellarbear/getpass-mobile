import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/components/restartableApp.dart';
import 'package:getpass/src/screens/settings/modals/languageModal.dart';

Widget languageTile(BuildContext context) {
  return StreamBuilder(
    stream: i18n.languageStream,
    builder: (context, AsyncSnapshot<I18nLangCode> langSnapshot) {
      final I18nLangCode language =
          langSnapshot.hasData ? langSnapshot.data : I18nLangCode.ENG;

      final String languageName = i18n.getLanguageMeta(code: language).name;

      return InkWell(
        onTap: () async {
          final returnValue = await showDialog<I18nLangCode>(
            context: context,
            builder: (BuildContext context) {
              return languageModal(context);
            },
          );

          if (returnValue != null) {
            i18n.languageOnChange(returnValue);

            RestartableApp.restartApp(context);
          }
        },
        child: ListTile(
          title:
              Text('${i18n.get(at: I18n.ChangeLanguageTitle)}: $languageName'),
          trailing: Container(
            margin: EdgeInsets.only(right: 4.0),
            child: Image.asset(
              'assets/localization/${i18n.getLanguageMeta(code: language).assetPath}',
              width: 20,
              height: 20,
            ),
          ),
        ),
      );
    },
  );
}
