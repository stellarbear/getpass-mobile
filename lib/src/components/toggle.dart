import 'package:flutter/material.dart';

Widget Toggle({bool value, Function(bool) onChange, String text}) {
  return InkWell(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Switch(
          value: value,
          onChanged: onChange,
        ),
        Opacity(
          opacity: value ? 1.0 : 0.4,
          child: Text(text),
        ),
      ],
    ),
    onTap: () => onChange(!value),
  );
}
