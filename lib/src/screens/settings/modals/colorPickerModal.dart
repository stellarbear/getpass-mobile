import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:getpass/src/bloc/localization.dart';

Widget colorPickerModal(BuildContext context, Color selectedColor) {
  Color newColor;

  return AlertDialog(
    content: MaterialColorPicker(
      onColorChange: (Color color) {
        newColor = color;
      },
      selectedColor: selectedColor,
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(i18n.get(at: I18n.Cancel)),
        onPressed: () => Navigator.pop(context),
      ),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          i18n.get(at: I18n.Update),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.pop(context, newColor);
        },
      )
    ],
  );
}
