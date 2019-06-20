import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/colorTheme.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/screens/settings/modals/colorPickerModal.dart';

Widget colorPickerPrimaryTile(BuildContext context, ColorTheme colorTheme) {
  final Color selectedColor = colorTheme.getPrimaryColor;

  return InkWell(
    onTap: () async {
      final newColor = await showDialog<Color>(
        context: context,
        builder: (BuildContext context) {
          return colorPickerModal(context, selectedColor);
        },
      );

      if (newColor != null) {
        colorThemeBloc
            .colorOnChange(colorTheme.copyWith(primaryColor: newColor.value));
      }
    },
    child: ListTile(
      title: Text(i18n.get(at: I18n.PrimaryColorTitle)),
      trailing: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    ),
  );
}
