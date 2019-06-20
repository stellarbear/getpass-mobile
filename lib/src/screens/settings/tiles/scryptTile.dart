import 'package:flutter/material.dart';
import 'package:getpass/src/bloc/localization.dart';
import 'package:getpass/src/bloc/settings.dart';

Widget scryptTile(BuildContext context, Settings settings) {
  final costFactor = settings.costFactor;
  final blockSizeFactor = settings.blockSizeFactor;

  String humanReadableCostFactor = '$costFactor: ${1 << costFactor}';
  String humanReadableBlockSizeFactor =
      '${(1000 * (1 << costFactor) * blockSizeFactor * 128 / 1024 / 1024).round() / 1000} Mb';

  return Column(
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Text(
          i18n.get(at: I18n.ScryptWarning),
          textAlign: TextAlign.justify,
        ),
      ),
      ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(i18n.get(at: I18n.ScryptCostFactor)),
            Text(humanReadableCostFactor),
          ],
        ),
        subtitle: Slider(
          min: 1.0,
          max: 24.0,
          value: costFactor.toDouble(),
          divisions: 20,
          onChanged: (double value) {
            settingsBloc
                .settingsOnChange(settings.copyWith(costFactor: value.toInt()));
          },
        ),
      ),
      ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(i18n.get(at: I18n.ScryptBlockSizeFactor)),
            Text(humanReadableBlockSizeFactor),
          ],
        ),
        subtitle: Slider(
          min: 1.0,
          max: 24.0,
          value: blockSizeFactor.toDouble(),
          divisions: 20,
          onChanged: (double value) {
            settingsBloc.settingsOnChange(
                settings.copyWith(blockSizeFactor: value.toInt()));
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: RaisedButton(
                child: Text(
                  i18n.get(at: I18n.ScryptDefault),
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  settingsBloc.settingsOnChange(settings.copyWith(
                    costFactor: Settings.costFactorDefault,
                    blockSizeFactor: Settings.blockSizeFactorDefault,
                  ));
                },
              ),
            ),
            RaisedButton(
              child: Text(
                i18n.get(at: I18n.ScryptTough),
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                settingsBloc.settingsOnChange(settings.copyWith(
                  blockSizeFactor: 8,
                  costFactor: 16,
                ));
              },
            ),
          ],
        ),
      ),
    ],
  );
}
